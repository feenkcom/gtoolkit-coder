Class {
	#name : #GtPharoMethodExpanderStylerExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Pharo-Examples-Stylers'
}

{ #category : #examples }
GtPharoMethodExpanderStylerExamples >> expanderAttribute [
	<gtExample>
	| coder text index |

	coder := GtPharoMethodCoder forClass: Collection source: 'foo self do: [:each | Transcript print: each]'.
	text := coder sourceText copy.

	GtPharoMethodExpanderStyler new
		coderViewModel: coder asCoderViewModel;
		style: text ast: coder astAwait.

	index := text asString indexOfSubCollection: 'do:'.
	self assert: (self indexOfExpanderIn: text) equals: (index + 2).

	^ text
]

{ #category : #private }
GtPharoMethodExpanderStylerExamples >> indexOfExpanderIn: ropedText [
	1 to: ropedText size do: [ :i | 
		((ropedText attributesAt: i)
			anySatisfy: [ :attr | attr isKindOf: GtPharoMethodExpanderAttribute ])
			ifTrue: [ ^ i ] ].
	^ -1
]

{ #category : #'examples - literals' }
GtPharoMethodExpanderStylerExamples >> messageToArrayLiteral [
	<gtExample>	
	| coder text |

	coder := GtPharoMethodCoder forClass: Object source: 'foo ^#(a $a nil) isArray'.
	text := coder sourceText copy.

	GtPharoMethodExpanderStyler new
		coderViewModel: coder asCoderViewModel;
		style: text ast: coder astAwait.

	self
		assert:
			((self methodExpanderAttributesIn: text)
				anySatisfy: [ :each | each compiledMethod = (Array >> #isArray) ]).
	^ text
]

{ #category : #'examples - literals' }
GtPharoMethodExpanderStylerExamples >> messageToByteArrayLiteral [
	<gtExample>	
	| coder text |

	coder := GtPharoMethodCoder forClass: Object source: 'foo ^#[0 64 128 255] hex'.
	text := coder sourceText copy.

	GtPharoMethodExpanderStyler new
		coderViewModel: coder asCoderViewModel;
		style: text ast: coder astAwait.

	self
		assert:
			((self methodExpanderAttributesIn: text)
				anySatisfy: [ :each | each compiledMethod = (ByteArray >> #hex) ]).
	^ text
]

{ #category : #'examples - literals' }
GtPharoMethodExpanderStylerExamples >> messageToCharacterLiteral [
	<gtExample>	
	| coder text |

	coder := GtPharoMethodCoder forClass: Object source: 'foo ^$A asLowercase'.
	text := coder sourceText copy.

	GtPharoMethodExpanderStyler new
		coderViewModel: coder asCoderViewModel;
		style: text ast: coder astAwait.

	self
		assert:
			((self methodExpanderAttributesIn: text)
				anySatisfy: [ :each | each compiledMethod = (Character >> #asLowercase) ]).
	^ text
]

{ #category : #'examples - literals' }
GtPharoMethodExpanderStylerExamples >> messageToFalseLiteral [
	<gtExample>	
	| coder text |

	coder := GtPharoMethodCoder forClass: Object source: 'foo ^false asBit'.
	text := coder sourceText copy.

	GtPharoMethodExpanderStyler new
		coderViewModel: coder asCoderViewModel;
		style: text ast: coder astAwait.

	self
		assert:
			((self methodExpanderAttributesIn: text)
				anySatisfy: [ :each | each compiledMethod = (False>>#asBit) ]).
	^ text
]

{ #category : #'examples - literals' }
GtPharoMethodExpanderStylerExamples >> messageToFloatLiteral [
	<gtExample>	
	| coder text |

	coder := GtPharoMethodCoder forClass: Object source: 'foo ^3.14 isFinite'.
	text := coder sourceText copy.

	GtPharoMethodExpanderStyler new
		coderViewModel: coder asCoderViewModel;
		style: text ast: coder astAwait.

	self
		assert:
			((self methodExpanderAttributesIn: text)
				anySatisfy: [ :each | each compiledMethod = (Float >> #isFinite) ]).
	^ text
]

{ #category : #examples }
GtPharoMethodExpanderStylerExamples >> messageToGlobal [
	<gtExample>
	| coder text |

	coder := GtPharoMethodCoder forClass: Object source: 'foo Transcript print: each'.
	text := coder sourceText copy.

	GtPharoMethodExpanderStyler new
		coderViewModel: coder asCoderViewModel;
		style: text ast: coder astAwait.

	self
		assert:
			((self methodExpanderAttributesIn: text)
				anySatisfy: [ :each | each selector = #print: ]).

	^ text
]

{ #category : #'examples - literals' }
GtPharoMethodExpanderStylerExamples >> messageToIntegerLiteral [
	<gtExample>	
	| coder text |

	coder := GtPharoMethodCoder forClass: Object source: 'foo ^42 odd'.
	text := coder sourceText copy.

	GtPharoMethodExpanderStyler new
		coderViewModel: coder asCoderViewModel;
		style: text ast: coder astAwait.

	self
		assert:
			((self methodExpanderAttributesIn: text)
				anySatisfy: [ :each | each compiledMethod = (SmallInteger >> #odd) ]).
	^ text
]

{ #category : #'examples - literals' }
GtPharoMethodExpanderStylerExamples >> messageToNilLiteral [
	<gtExample>	
	| coder text |

	coder := GtPharoMethodCoder forClass: Object source: 'foo ^nil isNil'.
	text := coder sourceText copy.

	GtPharoMethodExpanderStyler new
		coderViewModel: coder asCoderViewModel;
		style: text ast: coder astAwait.

	self
		assert:
			((self methodExpanderAttributesIn: text)
				anySatisfy: [ :each | each compiledMethod = (UndefinedObject >> #isNil) ]).
	^ text
]

{ #category : #'examples - literals' }
GtPharoMethodExpanderStylerExamples >> messageToStringLiteral [
	<gtExample>	
	| coder text |

	coder := GtPharoMethodCoder forClass: Object source: 'foo ^''ipsum'' onlyLetters'.
	text := coder sourceText copy.

	GtPharoMethodExpanderStyler new
		coderViewModel: coder asCoderViewModel;
		style: text ast: coder astAwait.

	self
		assert:
			((self methodExpanderAttributesIn: text)
				anySatisfy: [ :each | each compiledMethod = (String >> #onlyLetters) ]).
	^ text
]

{ #category : #'examples - literals' }
GtPharoMethodExpanderStylerExamples >> messageToSymbolLiteral [
	<gtExample>	
	| coder text |

	coder := GtPharoMethodCoder forClass: Object source: 'foo ^#ipsum asMutator'.
	text := coder sourceText copy.

	GtPharoMethodExpanderStyler new
		coderViewModel: coder asCoderViewModel;
		style: text ast: coder astAwait.

	self
		assert:
			((self methodExpanderAttributesIn: text)
				anySatisfy: [ :each | each compiledMethod = (Symbol >> #asMutator) ]).
	^ text
]

{ #category : #'examples - literals' }
GtPharoMethodExpanderStylerExamples >> messageToTrueLiteral [
	<gtExample>	
	| coder text |

	coder := GtPharoMethodCoder forClass: Object source: 'foo ^true asBit'.
	text := coder sourceText copy.

	GtPharoMethodExpanderStyler new
		coderViewModel: coder asCoderViewModel;
		style: text ast: coder astAwait.

	self
		assert:
			((self methodExpanderAttributesIn: text)
				anySatisfy: [ :each | each compiledMethod = (True>>#asBit) ]).
	^ text
]

{ #category : #private }
GtPharoMethodExpanderStylerExamples >> methodExpanderAttributesIn: ropedText [
	| attributes |
	attributes := OrderedCollection new.
	1 to: ropedText size do: [ :i | 
		(ropedText attributesAt: i)
			do: [ :attr | 
				(attr isKindOf: GtPharoMethodExpanderAttribute)
					ifTrue: [ attributes add: attr ] ] ].
	^ attributes
]

{ #category : #examples }
GtPharoMethodExpanderStylerExamples >> missingSelfSend [
	<gtExample>
	| coder text |

	coder := GtPharoMethodCoder forClass: Collection source: 'foo self nonExistentMethod: [:each | Transcript print: each]'.
	text := coder sourceText copy.

	GtPharoMethodExpanderStyler new
		coderViewModel: coder asCoderViewModel;
		style: text ast: coder astAwait.

	self
		assert:
			((self methodExpanderAttributesIn: text)
				allSatisfy: [ :each | each selector ~= #nonExistentMethod ]).
	^ text
]

{ #category : #examples }
GtPharoMethodExpanderStylerExamples >> missingSuperSend [
	<gtExample>
	| coder text |

	coder := GtPharoMethodCoder forClass: Collection source: 'foo super do: [:each | Transcript print: each]'.
	text := coder sourceText copy.

	GtPharoMethodExpanderStyler new
		coderViewModel: coder asCoderViewModel;
		style: text ast: coder astAwait.

	self
		assert:
			((self methodExpanderAttributesIn: text)
				allSatisfy: [ :each | each selector ~= #do: ]).
	^ text
]

{ #category : #examples }
GtPharoMethodExpanderStylerExamples >> superExpanderAttribute [
	<gtExample>
	| coder text index |

	coder := GtPharoMethodCoder forClass: SequenceableCollection source: 'foo super do: [:each | Transcript print: each]'.
	text := coder sourceText copy.

	GtPharoMethodExpanderStyler new
		coderViewModel: coder asCoderViewModel;
		style: text ast: coder astAwait.

	index := text asString indexOfSubCollection: 'do:'.
	self assert: (self indexOfExpanderIn: text) equals: (index + 2).

	^ text
]
