Class {
	#name : #GtCoderExpandableClassTreeItemStencilBuilder,
	#superclass : #BrSimpleTreeRowStencilBuilder,
	#category : #'GToolkit-Coder-Navigation - Stencil'
}

{ #category : #private }
GtCoderExpandableClassTreeItemStencilBuilder >> buildLabel [
	<return: #BrLabel>
	^ super buildLabel 
		beSmall;
		margin: (BlInsets all: 1)
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
GtCoderExpandableClassTreeItemStencilBuilder >> defaultColumnedTreeRowStencilBuilder [
	^ GtCoderColumnedTreeRowStencilBuilder new
]

{ #category : #initialization }
GtCoderExpandableClassTreeItemStencilBuilder >> defaultText [
	^ [ :aNodeValue | self buildTextFor: aNodeValue ]
]
