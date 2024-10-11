Extension { #name : #GtSourceCoderShortcut }

{ #category : #'*GToolkit-Coder-Extensions' }
GtSourceCoderShortcut >> gtSourceCodeFor: aView [
	<gtView>
	^ aView forward
		title: 'Source';
		object: [ 
			(self class includesSelector: #performOnEditor:element:coderViewModel:dueTo:)
				ifTrue: [ self class >> #performOnEditor:element:coderViewModel:dueTo: ]
				ifFalse: [ self class >> #performOnEditor:element:coder:dueTo:requesterObject: ] ];
		view: #gtSourceFor:
]
