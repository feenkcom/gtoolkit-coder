Class {
	#name : #GtCoderNonExpandableClassTreeItemStencilBuilder,
	#superclass : #BrEmptyColumnedTreeRowStencilBuilder,
	#traits : 'TGtCoderNavigationClassesHelper',
	#classTraits : 'TGtCoderNavigationClassesHelper classTrait',
	#category : #'GToolkit-Coder-Navigation - UI'
}

{ #category : #private }
GtCoderNonExpandableClassTreeItemStencilBuilder >> fillExpander: anExpander for: aNode [
	super fillExpander: anExpander for: aNode.
	anExpander addChild: (self buildClassLabel: aNode value rootClass)
]
