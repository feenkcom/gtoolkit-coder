Class {
	#name : #GtPackageCoderTool,
	#superclass : #GtCoderTool,
	#category : #'GToolkit-Coder-Adaptors'
}

{ #category : #converting }
GtPackageCoderTool >> newCoderFor: anObject [
	^ GtCoder forPackage: anObject
]
