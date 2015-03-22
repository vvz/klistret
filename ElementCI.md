Each element amassed in the Element table has a _configuration_ column which derives from the Element CI.

## Description ##
The CI inherits from the [Base CI](BaseCI.md) and doesn't add a whole lot other than ownership.

### Characteristics ###
Every property below has the _http://www.klistret.com/cmdb/ci/commons_ namespace.  The Element CI is abstract.

| **Property** | **Description** | **Required** | **Unbounded** | **Key** | **Context** |
|:-------------|:----------------|:-------------|:--------------|:--------|:------------|
| Ownership | A complex type composed of either a _Name_ simple type or a complex _Contact_ with room for _Name_, _Telephone_, _EMail_, _Organization_, and _Function_.  The _Contact_ structure is immature and a candidate for revamping.  Regardless, Ownership tells others who is responsible for the instance. | No | No | No | Maybe |

## Usage ##
An Element CI is never instantiated but like the Relation CI splits the Base CI into 2 distinct camps.