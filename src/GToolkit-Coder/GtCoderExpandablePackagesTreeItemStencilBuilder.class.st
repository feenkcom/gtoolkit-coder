Class {
	#name : #GtCoderExpandablePackagesTreeItemStencilBuilder,
	#superclass : #BrSimpleTreeRowStencilBuilder,
	#category : #'GToolkit-Coder-Navigation - Stencil'
}

{ #category : #private }
GtCoderExpandablePackagesTreeItemStencilBuilder >> buildLabel [
	<return: #BrLabel>
	^ super buildLabel  
		beSmall;
		margin: (BlInsets all: 1)
]

{ #category : #'private - ui' }
GtCoderExpandablePackagesTreeItemStencilBuilder >> buildTextFor: aNodeValue [
	aNodeValue ifNil: [ ^ '' asRopedText ].
	^ aNodeValue name asRopedText
]

{ #category : #initialization }
GtCoderExpandablePackagesTreeItemStencilBuilder >> defaultColumnedTreeRowStencilBuilder [
	^ GtCoderColumnedTreeRowStencilBuilder new
]

{ #category : #initialization }
GtCoderExpandablePackagesTreeItemStencilBuilder >> defaultText [
	^ [ :aNodeValue | self buildTextFor: aNodeValue ]
]
