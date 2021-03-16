Class {
	#name : #GtCoderExampleStatusStyler,
	#superclass : #GtGenericPharoStyler,
	#category : #'GToolkit-Coder-AddOns-Example status'
}

{ #category : #'method coder styler' }
GtCoderExampleStatusStyler class >> examplePatternStylerFor: aMethodCoder [
	<gtMethodCoderPatternStyler: 5>
	aMethodCoder example isNil
		ifTrue: [ ^ nil ].
	^ self new
		coder: aMethodCoder;
		classOrMetaClass: aMethodCoder classOrMetaClass;
		yourself
]

{ #category : #generated }
GtCoderExampleStatusStyler >> visitMethod: aMethodNode [
	| anExample |

	anExample := self coderViewModel coderModel example.
	anExample
		ifNil: [ ^ self ].
	
	self
		attribute: (GtCoderExampleStatusAttribute forExample: anExample)
		from: aMethodNode pattern stopPosition
		to: aMethodNode pattern stopPosition
]
