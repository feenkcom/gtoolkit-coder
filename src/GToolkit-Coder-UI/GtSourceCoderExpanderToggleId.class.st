"
An element to toggle  {{gtClass:BrExpander}}'s state on click. In a context of a coder, an expander is a sidebar element that allows to collapse/expand a coder.
Do not confuse with an embedded expander within the text which is usually represented by a triangle.
"
Class {
	#name : 'GtSourceCoderExpanderToggleId',
	#superclass : 'GtCoderElementId',
	#category : 'GToolkit-Coder-UI-Coder - Basic'
}

{ #category : 'converting' }
GtSourceCoderExpanderToggleId >> asSymbol [
	^ #'source-coder--expander-toggle'
]
