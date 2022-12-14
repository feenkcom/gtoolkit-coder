Extension { #name : #GtPhlowElementContext }

{ #category : #'*GToolkit-Coder-UI' }
GtPhlowElementContext >> coder [
	<return: #GtCoder>
	| anElement |
	anElement := self firstParentWithView.
	self
		assert: [ anElement isNotNil ]
		description: [ 'Coder (element) must be non-nil' ].
	self
		assert: [ anElement isKindOf: GtCoder ]
		description: [ 'Coder (element) must be a kind of ' , GtCoder name ].

	^ anElement
]

{ #category : #'*GToolkit-Coder-UI' }
GtPhlowElementContext >> coderNavigationModel [
	<return: #GtCoderNavigationModel>
	| aCoder aNavigationModel |
	aCoder := self coder.
	aNavigationModel := aCoder navigationModel.

	self
		assert: [ aNavigationModel isNotNil ]
		description: [ 'Coder navigation model must be non-nil' ].

	^ aNavigationModel
]
