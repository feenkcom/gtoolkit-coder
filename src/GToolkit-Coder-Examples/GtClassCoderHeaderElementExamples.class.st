Class {
	#name : #GtClassCoderHeaderElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Behavior'
}

{ #category : #'examples - header' }
GtClassCoderHeaderElementExamples >> coderHeaderElementForClass [
	<gtExample>
	| aCoder aCoderHeaderElement |

	aCoder := GtClassCoderExamples new coderForClass.
	aCoder forClass: GtBehaviorCoderDummyClass.
	aCoderHeaderElement := GtBehaviorCoderHeaderElement new classCoder: aCoder.
	aCoderHeaderElement expand.

	^ aCoderHeaderElement
]

{ #category : #'examples - header' }
GtClassCoderHeaderElementExamples >> coderHeaderElementForMetaclass [
	<gtExample>
	| aCoder aCoderHeaderElement |

	aCoder := GtClassCoderExamples new coderForClass.
	aCoder forClass: GtBehaviorCoderDummyClass class.
	aCoderHeaderElement := GtBehaviorCoderHeaderElement new classCoder: aCoder.
	aCoderHeaderElement expand.

	^ aCoderHeaderElement
]

{ #category : #'examples - header' }
GtClassCoderHeaderElementExamples >> coderHeaderElementForTrait [
	<gtExample>
	| aCoder aCoderHeaderElement |

	aCoder := GtClassCoderExamples new coderForClass.
	aCoder forClass: TGtBehaviorCoderDummyTrait.
	aCoderHeaderElement := GtBehaviorCoderHeaderElement new classCoder: aCoder.
	aCoderHeaderElement expand.

	^ aCoderHeaderElement
]
