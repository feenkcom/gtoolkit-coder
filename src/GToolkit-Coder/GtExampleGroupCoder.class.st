Class {
	#name : #GtExampleGroupCoder,
	#superclass : #GtMethodsCoder,
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'instance creation' }
GtExampleGroupCoder >> newCoderFor: aMethod [
	| coder |
	coder := GtPharoMethodCoder forExample: aMethod.
	coder coders: self.
	^ coder
]
