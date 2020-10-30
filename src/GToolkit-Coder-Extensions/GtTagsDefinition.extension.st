Extension { #name : #GtTagsDefinition }

{ #category : #'*GToolkit-Coder-Extensions' }
GtTagsDefinition >> gtTagsFor: aView [
	<gtView>
	
	self isEmpty
		ifTrue: [ ^ aView empty ].
	
	^ aView list
		title: 'Tags';
		priority: 1;
		items: [ definitions ]
]
