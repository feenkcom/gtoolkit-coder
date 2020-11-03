Class {
	#name : #GtBehaviorCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Coders'
}

{ #category : #'instance creation' }
GtBehaviorCoderExamples >> forClass [
	<gtExample>
	| aCoder |

	aCoder := GtBehaviorCoder forClass: GtBehaviorCoderDummyClass.

	self assert: aCoder theClass equals: GtBehaviorCoderDummyClass.
	self assert: aCoder hasObject not.
	self assert: aCoder object equals: nil.

	self assert: aCoder methodsCoder classOrMetaClass equals: GtBehaviorCoderDummyClass.
	self assert: aCoder methodsCoder object equals: nil.

	self assert: aCoder definitionCoder behavior equals: GtBehaviorCoderDummyClass.

	^ aCoder
]

{ #category : #'instance creation' }
GtBehaviorCoderExamples >> forObject [
	<gtExample>
	| anObject aCoder |

	anObject := GtBehaviorCoderDummyClass new.

	aCoder := GtBehaviorCoder forObject: anObject.

	self assert: aCoder theClass equals: GtBehaviorCoderDummyClass.
	self assert: aCoder hasObject.
	self assert: aCoder object equals: anObject.

	self assert: aCoder methodsCoder classOrMetaClass equals: GtBehaviorCoderDummyClass.
	self assert: aCoder methodsCoder object equals: anObject.

	self assert: aCoder definitionCoder behavior equals: GtBehaviorCoderDummyClass.

	^ aCoder
]
