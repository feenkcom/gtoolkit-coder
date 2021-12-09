Extension { #name : #GtSourceCoderShortcut }

{ #category : #'*GToolkit-Coder-Extensions' }
GtSourceCoderShortcut >> gtSourceCodeFor: aView [ 
	<gtView>

	^ aView forward
		title: 'Source';
		object: [ self class >> #performOnEditor:element:coderViewModel:dueTo: ];
		view: #gtSourceFor:
]
