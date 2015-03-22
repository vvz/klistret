Perl can be a simple language to execute HTTP calls and process JSON responses.

# Introduction #
The contents of this article is geared to users of Perl on Unix like systems but the gist regarding programming as a client work for Perl on Windows.

# Perl Installation #
[Download](http://www.perl.org/get.html) Perl to a pack-up directory then following the steps below pointing the actual installation to another directory:
```
  cd <unpacking directory>
  gunzip perl-<version>.tar.gz
  tar xvf perl-<version>.tar
  cd perl-<version>
  export PATH=$PATH:/usr/ccs/bin
  sh Configure -de -Dprefix='<installation directory' -Dcc=gcc
  make
  make install
```

## HTTP Tiny ##
Communication to Klistret goes through HTTP GET/PUT/POST/DELETE calls and an easy way is to use [HTTP Tiny](http://www.dagolden.com/index.php/1212/why-httptiny).  Installing modules is easy if you have a Perl installation that can be modified (otherwise the "--prefix" argument is a must).  HTTP Tiny is included in at least Perl 5.14.

## JSON ##
A standard data format is JSON and one of the better modules is [JSON](https://metacpan.org/module/JSON) which requires [JSON-XS](https://metacpan.org/module/JSON::XS) and something called [Common Sense](https://metacpan.org/module/common::sense).

## CGI ##
The last piece of the basic puzzle is [CGI](https://metacpan.org/module/CGI) which is helpful for encoding URLs (especially query strings).  Escaping query strings is necessary.  A good online tool to check encoding is [a String converter](http://coderstoolbox.net/string).

## Date ##
A good [date formatting](http://search.cpan.org/~gbarr/TimeDate-1.20/lib/Date/Format.pm) extension is helpful when creating elements.

# Finding stuff #
Searching after CI in Klistret is a matter of filtering with XPath statements.  For example, the following series of XPath expressions will pull back software belongs to a particular module and version:
```
  1) declare namespace pojo="http://www.klistret.com/cmdb/ci/pojo"; /pojo:Element[empty(pojo:toTimeStamp)]/pojo:type[pojo:name eq "{http://www.klistret.com/cmdb/ci/element/component}Software"]

  2) declare namespace pojo="http://www.klistret.com/cmdb/ci/pojo"; /pojo:Element[pojo:name = ("INF")]

  3) declare namespace pojo="http://www.klistret.com/cmdb/ci/pojo"; declare namespace component="http://www.klistret.com/cmdb/ci/element/component"; /pojo:Element/pojo:configuration[component:Version eq "0068_A01"]
```

Every CI is either an Element or Relation class.  It is recommended that users try to return a specific type of CI which is what the first XPath expression does.  It specifies that the CI must be active [_toTimeStamp_ is null] and that the CI type is _Software_.  The module name is the same as the name property for Software as filtered in the second expression.  The last expression weans the search down to a version called 0068\_A01.

## Writing queries in Perl ##
There is more information about how to formulate a XPath expression on the CI pages.  But what about writing a series of filters in Perl?  The first thing to do is setup the necessary modules and the URL to Klistret:
```
  use HTTP::Tiny;
  use Encode;
  use CGI;
  use JSON;
  use Date::Format;

  use strict;
  use warnings;

  ##############################################################
  # URL to Element service
  ##############################################################
  my $elementService = 'http://<address>:<port>/CMDB/resteasy/element';

  # Restrictions
  my $restrictions = '?start=0&limit=20';

  # Expression clauses
  my $expressionClause = '&expressions=';
```

The **start** and **limit** variables in the query string tell Klistret to pull the very first database record up to 20 records thereafter.  So **limit** is the number of records to return while **start** is the starting record.

Transforming the sample expressions to a couple Perl scalars is pie outside of setting a useful name:
```
  ##############################################################
  # Filters
  ##############################################################
  my $typeAndActiveFilter = 'declare namespace pojo="http://www.klistret.com/cmdb/ci/pojo"; /pojo:Element[empty(pojo:toTimeStamp)]/pojo:type[pojo:name eq "{http://www.klistret.com/cmdb/ci/element/component}Software"]';

  my $moduleFilter = 'declare namespace pojo="http://www.klistret.com/cmdb/ci/pojo"; /pojo:Element[pojo:name = ("INF")]';

  my $versionFilter = 'declare namespace pojo="http://www.klistret.com/cmdb/ci/pojo"; declare namespace component="http://www.klistret.com/cmdb/ci/element/component"; /pojo:Element/pojo:configuration[component:Version eq "0068_A01"]';

  ##############################################################
  # Complete request
  ##############################################################
  my $request = $elementService . $restrictions . $expressionClause . CGI::escape($typeAndActiveFilter) . $expressionClause . CGI::escape($moduleFilter) . $expressionClause . CGI::escape(versionFilter);
```

Now we have a request in the form of a REST URL.  Each filter is appended to the query string as the variable _expressions_.  Only the filter strings need to be escaped.  The next step is to use HTTP Tiny to fire off the request and process the results:
```
  ##############################################################
  # Do HTTP Get
  ##############################################################
  my $response = HTTP::Tiny->new->request('GET', $request , {
    'headers' => { 'Accept' => 'application/json' }
  });
```

The options of the Tiny request force Klistret to return JSON data.  The response has set of constructs that get hashed into the _response_ variable.  The **success** is a Boolean flagging a positive return or not.  **Content** is another keeper since it holds the actual data payload:
```
  die "Failed! Status: " . $response->{status} . ", Reason: " .  $response->{reason} . ", Content: " . $response->{content} . "\n" unless $response->{success};
```

The payload is now in the _content_ property of the _response_ via Tiny.  We need to translate this JSON data into a Perl scalar.  It is important to treat the payload a UTF-8 encoded:
```
  my $json = new JSON;
  my $payload = $json->utf8->canonical->decode($response->{content});
```

Klistret will return a collection of elements so the best thing to do is loop through this data array (a deference is needed first):
```
  foreach my $element(@{$payload}){
    ... do stuff ...
  }
```

The JSON which Klistret recognizes is in the [Badgerfish](http://www.sklar.com/badgerfish) syntax.  Namespaces inherent to XML to differentiate elements with the same local name are present and prefixes to node names occur.  These namespaces are defined to the xmlns attribute.  To traverse the Perl scalar (as a hash) we need to access the prefixes based on our knowledge of expected namespaces:
```
  ##############################################################
  # Reverse the keys/values
  ##############################################################
  my $namespaces  = $element->{Element}->{'@xmlns'};
  my %rnamespaces = reverse %$namespaces;

  my $component = $rnamespaces{"http://www.klistret.com/cmdb/ci/element/component"};

  my $version = $element->{Element}->{configuration}->{$component  . ':Version'}->{'$'};
```

The **version** scalar now has the Version element's text.  Pretty easy.

# Updating #
Updating data is always simpler if we are dealing with data that has been pulled down from Klistret.

## Existing data from collections ##
Continuing on with the search explain from above we can update individual elements inside the for loop:
```
  $element->{Element}->{configuration}->{$component  . ':Version'}->{'$'} = "0068_A02";

  $response = HTTP::Tiny->new->request('PUT', $elementService, {
    content => $json->utf8->canonical->encode($element),
    headers => {
      'Content-Type' => 'application/json; charset=UTF-8',
      'Accept'       => 'application/json'
    }
  });
```

Remember that PUT in the world of [CRUD](http://en.wikipedia.org/wiki/Create,_read,_update_and_delete) is an update.  Again here we specify that the content type sent to Klistret is JSON and we want to accept JSON as a return value.

## Creating from thin air ##
The creation of elements adds a level of difficultly.  First we have to get the element type we want to create because it is a required property for all elements:
```
  ##############################################################
  # Element Type service
  ##############################################################
  my $elementTypeService = 'http://<address>:<port>/CMDB/resteasy/elementType';

  ##############################################################
  # Query string and request
  ##############################################################
  my $elementTypeNameQuery = '?name=' . CGI::escape('{http://www.klistret.com/cmdb/ci/element/component}Software');

  my $request = $elementTypeService . $elementTypeNameQuery;

  
  ##############################################################
  # Call service
  ##############################################################
  my $response = HTTP::Tiny->new->request('GET', $request , {
    'headers' => { 'Accept' => 'application/json' }
  });


  ##############################################################
  # Decode
  ##############################################################
  my $json = new JSON;
  my $payload = $json->utf8->canonical->decode($response->{content});

  my $elementType = @{$payload}[0];
```

The payload contains a collection but the size should be one.  What remains now is to build a template for the new element.  This requires knowledge about the CI like what properties are necessary or optional:
```
  my $element {
  'Element' => {
    '@xmlns' => {
      '$' => 'http://www.klistret.com/cmdb/ci/pojo',
      'element' => 'http://www.klistret.com/cmdb/ci/element',
      'component' => 'http://www.klistret.com/cmdb/ci/element/component',
      'commons' => 'http://www.klistret.com/cmdb/ci/commons'
    },

    'name' => {
      '$' => 'INF'
    },

    'type' => {
      'id' => {
        '$' => $elementType->{ElementType}->{id}->{'$'}
      },

      'name' => {
        '$' => $elementType->{ElementType}->{name}->{'$'}
      }
    },

    'fromTimeStamp' => {
      '$' => time2str("%Y-%m-%dT%H:%M:%S.000+02:00", time)
    },

    'createTimeStamp' => {
      '$' => time2str("%Y-%m-%dT%H:%M:%S.000+02:00", time)
    },

    'updateTimeStamp' => {
      '$' => time2str("%Y-%m-%dT%H:%M:%S.000+02:00", time)
    },

    'configuration' => {
      '@xmlns' => {
        'xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
      },

      '@xsi:type' => 'component:Software',

      'commons:Name' => {
        '$' => 'INF'
      },

      'component:Label' => {
        '$' => 'whatever is a INF'
      },

      'component:Organization' => {
        '$' => 'my comp'
      },

      'component:Version' => {
        '$' => '9999_B99'
      },

      'component:Type' => {
        '$' => 'important'
      }
    }
  }
  };

  ##############################################################
  # Call service
  ##############################################################
  $response = HTTP::Tiny->new->request('POST', $elementService, {
    content => $json->utf8->canonical->encode($element),
    headers => {
      'Content-Type' => 'application/json; charset=UTF-8',
      'Accept'       => 'application/json'
    }
  });
```

A simple POST does the trick.  The response will carry the created element (with a generated id).  Every time an element is created the above template will be reused (since the underlying placeholder for Element POJOs is a table with an XML column).  The differences lye in the **configuration** property where the CI metadata is actually stored.

## Identify ##
One gotcha is it is easy to create identical CI objects more than once.  If we where to run the Perl script above that creates a software CI twice we would get 2 identical elements but with different unique ids.  To avoid multiple instances of what the user defines as unique the **identification** service should be used prior to creation or update:
```
  my $identificationService = 'http://<address>:<port>/CMDB/resteasy/identification';

  ##############################################################
  # Call service
  ##############################################################
  $response = HTTP::Tiny->new->request('POST', $identificationService , {
    content => $json->utf8->canonical->encode($element),
    headers => {
      'Content-Type' => 'application/json; charset=UTF-8',
      'Accept'       => 'application/json'
    }
  });

  ##############################################################
  # Decode
  ##############################################################
  my $json = new JSON;
  my $count = $json->utf8->canonical->decode($response->{content});
```

A count of zero means the element posted is unique.  On the backend a series of identification rules are subjected to the element and a count of similar elements is returned.

# Relating stuff #
Beyond messing around with CI elements it is useful to have relationships between elements.  All of the REST services for elements except identification are exactly the same.  The only difference is that Relation POJOs are passed to a different path:
```
  'http://<address>:<port>/CMDB/resteasy/relation'
```

Relationships have types and the address to these is:
```
  'http://<address>:<port>/CMDB/resteasy/relationType'
```

## Establishing a relation ##
Be care with relations since no identification services presently exists.  A good rule of thumb is to find similar relations with XPath filters prior to creating new ones.  Creating relations mirrors what we did with elements.  First we make a template and populate that template often only with source and destination information.  For example a standard Relation template looks like:
```
  my $relation = {
    'Relation' => {
      '@xmlns' => {
        'relation' => 'http://www.klistret.com/cmdb/ci/relation',
        'commons' => 'http://www.klistret.com/cmdb/ci/commons',
        '$' => 'http://www.klistret.com/cmdb/ci/pojo'
      },

      'type' => {
        'id' => {
          '$' => <!-- Already got the relation type id? -->
        },

        'name' => {
          '$' => <!-- Already got the relation type name? -->
        }
      },

      'source' => <!-- Already got the source element? -->,

      'destination' => <!-- Already got the destination element? -->,

      'fromTimeStamp' => {
        '$' => time2str("%Y-%m-%dT%H:%M:%S.000+02:00", time)
      },

      'createTimeStamp' => {
        '$' => time2str("%Y-%m-%dT%H:%M:%S.000+02:00", time)
      },

      'updateTimeStamp' => {
        '$' => time2str("%Y-%m-%dT%H:%M:%S.000+02:00", time)
      },

      'configuration' => {
        '@xmlns' => {
          'xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
        },

        '@xsi:type' => 'relation:<relation type name, only the local part like Dependency>',

        'commons:name' => <something>
      }
    }
  };
```

The majority of relationships are dependencies, compositions or associations.

# Getting rid of data #
All of the CRUD services are present including delete.  Nothing ever gets totally deleted in Klistret rather tombstone in the form of the current time is placed on the element or relation.  For example, to delete an element the only the element ID is required:
```
  my elementId = <id from element>;

  $response = HTTP::Tiny->new->request('DELETE', $elementService . '/' . $elementId , {
    'headers' => { 'Accept' => 'application/json' }
  });
```