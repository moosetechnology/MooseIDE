(updated on oct. 13, 2021)

# Moose workspace

(Santi's stuff)
It allows to group several tools in one window.

It is a MiBrowser, so it listens and writes on bus(es)

It has an "internal bus" that it's children browsers listen and write

The workspace make the bridge between external bus(es) and its internal bus:
- takes incoming entities on external bus and send them on internal bus,
- takes entities on internal bus to propagate them on external bus(es).
- propagation on internal bus is automatic,
- propagation to external bus(es) is on demand

# Property Browser

A tool to define properties. A property has:
- a name
- a boolean query to decide if an entity has this property or not
- a color (optional?)

Note: Property is a kind of "virtual tag", or a tag computed on the fly but not stored in the model

The query will be taken from the Query Browser, for example:
Property: name="someName", color=red, query=Q1

So we need a mechanism to share queries between different tools.
This tool can ask the QueryBrowser, what are the queries available and allow to select one of the query to create a property from it

# TagBrowser

Possibility to define tags from properties

Add "virtual tags"

# Hierarchical Map with properties

Displays incoming entities in a hierarchicalView https://github.com/ObjectProfile/HierarchicalVisualizations

Has a list of properties (taken from PropertyBrowser)

For each displayed entity, if it matches one property query, will give the color of the property to the entity.

If an entity match several queries, 2 options:
- give a specific color (black, gray, red)
- choose the first one

# Favorites Browser

A tool to record some favorites "things" that the user like:
- launching a browser
- running a favorite query and automatically propagate the result on the bus(es)
locations)
- running a Property ???

# System complexity

Recreate the system complexity browser (3 metrics displayed with width, height, and color)
Entites are displayed in a tree

Possibly accept colored properties (with only 2 metrics with width and height)

Starting at a given level, containement is not shown as a tree, but as a HierarchicalVisualization

# Propagation strategy buses

We could have different kinds of buses:

- push bus: when data is written on the bus, it immediately transmits it to all tools attached to it
- delayed bus: when data is written on the bus, it stores it and only transmits when there is an explicit "flush" from the producer (allow to work with the "Propagate" button of the tools)
- pull buses, bus stores data and does not transmit it unless explicitly asked by a receiver tool

The last 2 are a bit similar: one is a flush from the producer to all consumers the other is a flush from the consumer only to itself.

This will allow to have:
- an internal bus for MooseWorkspace that transmit data immediately to all tools in the workspace (*push* internal bus) ;
- bus for separate tools that tranmit only on request (*delayed bus* + Propagate button) ; and
- a bus for some specific cases where we want to share data on demand:
 - to share queries (not their result, but the query itself),
 - share the properties defined in **Property Browser**
 - for santi to share is configurations


