Class {
	#name : #GtExampleGroupCoder,
	#superclass : #GtMethodsCoder,
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'instance creation' }
GtExampleGroupCoder >> newCoderFor: aMethod [
	| coder |
	coder := GtMethodCoder forExample: aMethod.
	coder methodsCoder: self.
	^ coder
]
