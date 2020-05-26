Class {
	#name : #GtCoderExpandableClassTreeItemStencilBuilder,
	#superclass : #BrSimpleTreeRowStencilBuilder,
	#category : #'GToolkit-Coder-Navigation - UI'
}

{ #category : #private }
GtCoderExpandableClassTreeItemStencilBuilder >> buildLabel [
	| aClass aBrLabel |
	aClass := self treeNode value rootClass.
	aBrLabel := super buildLabel.
	(aClass isAbstract or: [ aClass hasAbstractMethods ]) ifTrue: [ 
		aBrLabel look italic ].
	^ aBrLabel
]

{ #category : #'private - ui' }
GtCoderExpandableClassTreeItemStencilBuilder >> buildTextFor: aNodeValue [
	| aClass aText |
	aClass := aNodeValue rootClass.
	aText := aClass name asRopedText.
	(aClass isAbstract or: [ aClass hasAbstractMethods ]) ifTrue: [ 
		aText italic ].
	^ aText
]

{ #category : #initialization }
GtCoderExpandableClassTreeItemStencilBuilder >> defaultText [
	^ [ :aNodeValue | self buildTextFor: aNodeValue ]
]
