Extension { #name : #GtPhlowElementContext }

{ #category : #'*GToolkit-Coder-UI' }
GtPhlowElementContext >> coder [
	"Use #firstParentCoder instead"

	<return: #GtCoderElement>
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
	<return: #GtCoderElement>
	^ self element
		allParentsDetect: [ :parent | parent isKindOf: GtCoderElement ]
		ifFound: [ :parent | parent ]
		ifNone: [ self error: 'Couldn''t find a coder parent' ]
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
