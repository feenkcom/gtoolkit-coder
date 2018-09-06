ui
elementForOrderedCollectionMethods
	<gtExample>
	| container |
	container := BlElement new.
	container layout: BlLinearLayout vertical.
	container padding: (BlInsets all: 10).
	container
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	container addChildren: (self orderedCollectionMethods collect: [ :each | each asElement ]).
	^ container