Class {
	#name : #GtCoderColumnedTreeRowStencilBuilder,
	#superclass : #BrColumnedTreeRowStencilBuilder,
	#category : #'GToolkit-Coder-Navigation - Stencil'
}

{ #category : #private }
GtCoderColumnedTreeRowStencilBuilder >> createExpandCollapseElementFor: aNode [
	^ (super createExpandCollapseElementFor: aNode) beMini
]
