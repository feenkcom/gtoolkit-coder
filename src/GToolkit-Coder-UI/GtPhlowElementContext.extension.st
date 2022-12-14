Extension { #name : #GtPhlowElementContext }

{ #category : #'*GToolkit-Coder-UI' }
GtPhlowElementContext >> coder [
	"Use #firstParentCoder instead"

	<return: #GtCoder>
	^ self firstParentCoder
]

{ #category : #'*GToolkit-Coder-UI' }
GtPhlowElementContext >> coderNavigationModel [
	"Use #firstParentCoderNavigationModel instead"

	<return: #GtCoderNavigationModel>
	^ self firstParentCoderNavigationModel
]

{ #category : #'*GToolkit-Coder-UI' }
GtPhlowElementContext >> firstParentCoder [
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
GtPhlowElementContext >> firstParentCoderNavigationModel [
	<return: #GtCoderNavigationModel>
	| aCoder aNavigationModel |
	aCoder := self firstParentCoder.
	aNavigationModel := aCoder navigationModel.

	self
		assert: [ aNavigationModel isNotNil ]
		description: [ 'Coder navigation model must be non-nil' ].

	^ aNavigationModel
]
