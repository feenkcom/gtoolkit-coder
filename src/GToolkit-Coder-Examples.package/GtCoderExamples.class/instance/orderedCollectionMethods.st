model
orderedCollectionMethods
	<gtExample>
	| class |
	class := OrderedCollection.
	^ class selectors asSortedCollection collect: [ :each | GtMethodCoder forMethod: class >> each ]