Extension { #name : #GtTraitsDefinition }

{ #category : #'*GToolkit-Coder-Extensions' }
GtTraitsDefinition >> gtTraitsFor: aView [
	<gtView>
	
	definitions
		ifEmpty: [ ^ aView empty ].
	
	^ aView list
		title: 'Traits';
		priority: 1;
		items: [ definitions ]
]
