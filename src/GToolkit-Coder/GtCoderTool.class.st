Class {
	#name : #GtCoderTool,
	#superclass : #GtPhlowTool,
	#category : #'GToolkit-Coder-Adaptors'
}

{ #category : #converting }
GtCoderTool >> asElementDo: aOneArgBlock context: aContext [
	"Create a tool element and execute the block.
	A context can be passed to build the tool element."

	aOneArgBlock cull: self newCoder asPagerPageElement
]

{ #category : #converting }
GtCoderTool >> newCoder [
	^ self subclassResponsibility
]
