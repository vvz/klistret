The entire Software structure in Klistret is taken from the [Ivy](http://ant.apache.org/ivy/) framework.  It is only natural to be able to register Software and Publication CIs plus their relationships via an extension to Klistret (part of the Blueprints project).

## Description ##
Ivy modules, publications, and dependencies map without deviation to [Software CIs](SoftwareCI.md), [Publication CIs](PublicationCI.md) och Dependency CIs i Klistret.  However, Klistret does not work like package repository rather repositories (like [Ibiblio](http://www.ibiblio.org/)) actually manage artifacts (like [Archiva](http://archiva.apache.org/)) whereas Klistret federates a percentage of a repository's metadata.  So the complete flora of metadata latent to Ivy description files isn't fully mirrored.  Klistret harbors just enough metadata to register CIs.

A plugin for Ivy exists in the Blueprint project.  The plugin is responsible for registering an Ivy module description (i.e. XML document) and exporting out software CIs as an Ivy description file.  The plugin is very basic.  It relies almost to 100 percent on the user feeding the correct information.  The process of registering Ivy module description should not be confused with Ivy publishing or resolving.

### Mapping ###
This section maps sections of the Ivy module description to CI properties.  Ivy attributes that are not noted are not handled by the Ivy plugin.  The _branch_ attribute is part of the _info_ section but not listed below which means it is not mapped by the Ivy plugin.

#### Software ####
The Softare CI is based solely on the metadata located in the _info_ section of the Ivy module descriptor.
| **Section** | **Attribute** | **Klistret** | **Required** | **Description** |
|:------------|:--------------|:-------------|:-------------|:----------------|
| info | organisation | Organisation | Yes | Direct transfer from Ivy's organisation attribute into the organisation property for Software |
| info | module | Name | Yes | The module is the Software and thus the module attribute becomes the _Name_ property for both the Element POJO and the commons _Name_ property part of the Base CI. |
| info | revision | Version | Yes | Ivy use the title _revision_ while Klistret sticks to the more common _Version_. |
| info | status | Phase | No | Ivy describe _status_ the way people regard a module revision.  This is close enough to the Lifecycle or _Phase_ property.  For example, the **integration** status is a revision _built by a continuous build, a nightly build_ etc.  This is the same has software stuck in the development phase.  Ivy also defines **milestones** and **releases** which are akin to test and production phases.  The actual value of _Phase_ should derive from a contextual CI.  It is something every organization should define both for their internal work and external third party software. |
| info | publication | Availability | No | Ivy does not require the _publication_ attribute and neither does Klistret but it may be used to specific time frames thus mapping to the _Availability_ property. |

#### Publication ####
Publication CIs are made from the _artifact_ elements in the _publications_ section and Dependency CIs are created per artifact to the owning Software.
| **Section** | **Attribute** | **Klistret** | **Required** | **Description** |
|:------------|:--------------|:-------------|:-------------|:----------------|
| publications.artifact | name | Name | Yes | The artifact name is the _Name_ property for the Publication Element POJO and the commons _Name_ property part of the Base CI |
| publications.artifact | type | Type | Yes | Types are described on the [Publication CI](PublicationCI.md) page and these should definitely be predefined as contextual CIs. |
| publications.artifact | ext | Extension | Yes | Also described in detail on the [Publication CI](PublicationCI.md) page. |
| publications.artifact | conf | Usage | No | The configuration construction native to Ivy is not mapped into a Klistret structure rather forced into the _Usage_ property in the Base CI in the dependency relation created between the Software from the _info_ section and the current _artifact_ in the _publications_ section. |

#### Software Dependency ####
An Ivy dependency translates to a Dependency CI between 2 Software CI.  The _dependency_ element of the _dependencies_ section contains the criterion to locate or create a destination Software CI.
| **Section** | **Attribute** | **Klistret** | **Required** | **Description** |
|:------------|:--------------|:-------------|:-------------|:----------------|
| dependencies.dependency | org | Organisation | Yes | Organization of the destination software. |
| dependencies.dependency | name | Name | Yes | Name of the destination software (Element POJO _Name_ property) |
| dependencies.dependency | rev | Version | Yes | Version of the destination software. Variables can even identify a version by different aspects (See below) if an explicit version is not given. |
| dependencies.dependency | conf | Usage | No | Just like the configuration _conf_ attribute for publications the _Usage_ property is utilized. |

The [Ivy reference](http://ant.apache.org/ivy/history/latest-milestone/ivyfile/dependency.html) talks about how variables can be used to locate a particular revision.  The majority of Ivy variables are supported and expect _Tag_ metadata to find a Software CI:
  * **latest.`[`any status`]`** works just like Ivy states in Klistret.  If one writes **latest.release** then a similar _Tag_ _latest.release_ must be present in Software CI and the _Phase_ property equal to the value _release_.  So the **lastest.integration** variable is not handled differently rather generally under the expectation that _integration_ is the _Phase_ aspect.  Klistret finds the greatest revision for the status or phase aspect.
  * **version ranges** are not yet supported.
  * **latest.`[`any publication`]`** is not a construct from Ivy but is interpreted by Klistret.  Publication dates are also an important aspect in Klistret and correspond to the _Availability_ property.  The variable _latest.2011-10-01_ instructs Klistret to search for a Software CI with _latest.2011-10-01_  _Tag_ and an _Availability_ equal to _2011-10-01_.
  * **latest.`[`any status`]`.`[`any publication`]`** is also no construction in Ivy but Klistret looks for a _Tag_ called _latest.phase.availability_ and matches against both the _Phase_ and _Availability_ properties.

Who sets all of the tags?  There are 3 different tags (_latest.phase_, _latest.availability_, and _latest.phase.availability_) that have to exist otherwise the Ivy plugin won't recognize software by variable.  Registration of software through the Ivy plugin with infilled status and publication will automatically apply Ivy tags.  If the status and publication values are not present then the software will disappear from variable specification unless the end user applies the tags manually.  Also, manual interference can by accident lead to Klistret finding multiple CI per tag which will fail inside the Ivy plugin.  So there is a good deal of responsibility on the part of the end user to preserve the integrity tagging.

## Registration ##
The Ivy module descriptor (XML document) is the information carrier to the follow REST service:
> /resteasy/ivy

The PUT HTTP method is used since an [idempotent](http://en.wikipedia.org/wiki/Idempotent) action is expected.    Idempotent actions means that the same result is excepted if the Software CI already exists or is updated.  The same logic covers how relations to publications and other software are handled.  When an Ivy descriptor file is registered it is a snapshot of how dependencies are resolved at that point in time.  In other words, if _rev_ variables are used when software dependencies are made against latest software by either phase or availability aspects valid at registration time.  This may differ from the build during development.  The recommendation is to always specify an explicit _rev_ value for software dependencies.

If no Software CI exists (based on the organization, module, and revision criteria) then a new Software CI is created otherwise an update is performed.  Should Klistret find more than one preexisting software meeting the identification criteria then the registration will fail.  Updating a persistent software ensues the deletion of all Ivy dependencies (i.e. relations to publications and other software) by actually deleting the Software CI and replacing it with a new Software CI.  Publication dependencies are created if not located and the Dependency CI (relation) is setup between the two elements.  Software dependencies are never created unless the _rev_ attribute is explicit and the registration will fail if no target software is found with a variable _rev_ value.  With _rev_ variables the value will be stored as a _Tag_ in the Dependency CI to indicate how the dependency was established.

During registration of both the qualified module and the software dependencies that are not persistent but have an explicit revision the resulting Version property must be an ordered value comparable to previously used versions for the same module.

The beta of plugin will not create contextual Lifecycle or Timeframe CIs until development is complete.

## Search ##
A HTTP GET against:
> /resteasy/ivy?org=`<`value`>`&module=`<`value`>`&revision=`<`value`>`

will return a single Ivy descriptor file.  The _revision_ may be either an implicit or explicit value however the service will fail if a unique element is not found.  Dependencies to the identified Software element will be returned with implicit revisions (_rev_ variable) if registered with implicit variables.  All relations to publications or other software reflect those at the time of registration.

The explicit revision values may be applied to reflect the exact revisions of dependencies during registration using the following URL:
> /resteasy/ivy/explicit?org=`<`value`>`&module=`<`value`>`&revision=`<`value`>`

The transient service show the dependencies currently active.  This is interesting if a dependency was implicitly registered to see what the latest version has become:
> /resteasy/ivy/transient?org=`<`value`>`&module=`<`value`>`&revision=`<`value`>`

It should be noted that the if registered the original Ivy descriptor for software is never stored or retrievable.