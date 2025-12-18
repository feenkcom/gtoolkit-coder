Class {
	#name : #GtExpandedCoderElementStencil,
	#superclass : #GtCoderElementStencil,
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #'api - instantiation' }
GtExpandedCoderElementStencil >> defaultElement [
	<return: #BlElement>
	^ GtSourceCoderExpandedContentElement new
]
