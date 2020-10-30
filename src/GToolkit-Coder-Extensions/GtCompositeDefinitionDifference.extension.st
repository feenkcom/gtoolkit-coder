Extension { #name : #GtCompositeDefinitionDifference }

{ #category : #'*GToolkit-Coder-Extensions' }
GtCompositeDefinitionDifference >> gtDifferencesFor: aView [
	<gtView>
	
	^ aView list
		title: 'Differences';
		priority: 1;
		items: [ self differences ]
]
