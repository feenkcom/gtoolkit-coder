"
I am an abstract class.
I am an {{gtClass:BlElement}}.
I provide basic {{gtClass:TBrLayoutResizable}} methods.
See my {{gtClass:GtCoderElement|expanded|show=#gtSubclassesFor:}} for concrete implementations:


"
Class {
	#name : #GtCoderElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #initialization }
GtCoderElement >> initialize [
	super initialize.
	
	self matchParent
]
