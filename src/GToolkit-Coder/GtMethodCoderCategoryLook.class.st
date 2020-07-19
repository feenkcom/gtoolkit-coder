Class {
	#name : #GtMethodCoderCategoryLook,
	#superclass : #GtSourceCoderLook,
	#instVars : [
		'tags'
	],
	#category : #'GToolkit-Coder-UI - Source Coder Look'
}

{ #category : #initialization }
GtMethodCoderCategoryLook >> initialize [
	super initialize.

	tags := self newTagsElement.

	self addChangeAddChildAs: #(content tags) with: [ tags ]
]

{ #category : #'instance creation' }
GtMethodCoderCategoryLook >> newTagsElement [
	^ self newTagsElementClass new
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignRight.
			c ignored vertical alignBottom ];
		zIndex: 10
]

{ #category : #'instance creation' }
GtMethodCoderCategoryLook >> newTagsElementClass [
	^ GtMethodCoderTagsElement
]

{ #category : #hooks }
GtMethodCoderCategoryLook >> onCoderChanged: aCoder [
	tags coder: aCoder
]
