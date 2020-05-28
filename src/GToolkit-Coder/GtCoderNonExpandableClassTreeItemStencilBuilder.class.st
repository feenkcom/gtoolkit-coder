Class {
	#name : #GtCoderNonExpandableClassTreeItemStencilBuilder,
	#superclass : #BrEmptyColumnedTreeRowStencilBuilder,
	#category : #'GToolkit-Coder-Navigation - Stencil'
}

{ #category : #private }
GtCoderNonExpandableClassTreeItemStencilBuilder >> buildLabel [
	<return: #BrLabel>
	^ (BrColumnCellLabelStencil new text: self buildText) asElement beSmall
]

{ #category : #'private - ui' }
GtCoderNonExpandableClassTreeItemStencilBuilder >> buildText [
	^ self buildTextFor: self treeNode value
]

{ #category : #'private - ui' }
GtCoderNonExpandableClassTreeItemStencilBuilder >> buildTextFor: aNodeValue [
	| aClass aText |
	aClass := aNodeValue rootClass.
	aText := aClass name asRopedText.
	(aClass isAbstract or: [ aClass hasAbstractMethods ]) ifTrue: [ 
		aText italic ].
	^ aText
]

{ #category : #private }
GtCoderNonExpandableClassTreeItemStencilBuilder >> fillExpander: anExpander for: aNode [
	super fillExpander: anExpander for: aNode.
	anExpander addChild: self buildLabel.
]
