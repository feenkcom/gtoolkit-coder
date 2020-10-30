"
!How to work with method coder
${class:GtMethodCoder}$ plays an important role in ${class:GtCoder}$ and ==Glamorous Toolkit==. It is a self sufficient molecula in the ecosystem of editors and can be embedded in various contexts. Method Coder is moldable and can be extended with the help of its ==add-on== mechanism.
An instance of the Method Coder doesn't have any knowledge of the UI state and is responsible for a low level method editing and refactoring. It can be created directly from a compiled method:
${example:GtCoderWorkWithMethodCoderHowToGuide>>#coderForMethod|codeExpanded=true}$
However, when embedding a method coder as a UI component we often want to be able to specify (or save/restore) its initial UI state, such as expansion or a focus state. ${class:GtMethodCoderUIModel}$ fascilicates users with that ability.
!!Method Coder's UI model
To create a default ${class:GtMethodCoderUIModel}$ for an existing instance of ${class:GtMethodCoder}$ it is enough to send a ${method:GtCoderModel>>#asCoderUIModel}$ message to that coder model. By default, the method coder does not have a focus and is not expanded:
${example:GtCoderWorkWithMethodCoderHowToGuide>>#uiModelForCoder|codeExpanded=true}$
!!!How to expand it?
Users may choose to visually expand a method coder:
${example:GtCoderWorkWithMethodCoderHowToGuide>>#expandedMethodCoder|codeExpanded=true|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=140}$
!!!How to give it focus?
Or also give it a focus by default:
${example:GtCoderWorkWithMethodCoderHowToGuide>>#expandedAndFocusedMethodCoder|codeExpanded=true|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=140}$
"
Class {
	#name : #GtCoderWorkWithMethodCoderHowToGuide,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-! HowTo'
}

{ #category : #'instance creation' }
GtCoderWorkWithMethodCoderHowToGuide >> coderForMethod [
	<gtExample>
	
	^ GtMethodCoder forMethod: GtBehaviorCoderDummyClass >> #instVarB:
]

{ #category : #'examples - method coder' }
GtCoderWorkWithMethodCoderHowToGuide >> expandedAndFocusedMethodCoder [
	<gtExample>
	| aCoderUIModel |

	aCoderUIModel := self expandedMethodCoder.
	aCoderUIModel focused: true.
	
	^ aCoderUIModel
]

{ #category : #'examples - method coder' }
GtCoderWorkWithMethodCoderHowToGuide >> expandedAndFocusedMethodCoderElement [
	<gtExample>
	| aCoderUIModel aMethodCoderElement |

	aCoderUIModel := self expandedAndFocusedMethodCoder.
	aMethodCoderElement := aCoderUIModel asElement.
	
	self assert: aMethodCoderElement isExpanded equals: true.
	self assert: aMethodCoderElement hasFocus equals: true.
	
	^ aMethodCoderElement
]

{ #category : #'examples - method coder' }
GtCoderWorkWithMethodCoderHowToGuide >> expandedMethodCoder [
	<gtExample>
	| aCoderUIModel |

	aCoderUIModel := self uiModelForCoder.
	aCoderUIModel expanded: true.
	
	^ aCoderUIModel
]

{ #category : #'examples - method coder' }
GtCoderWorkWithMethodCoderHowToGuide >> expandedMethodCoderElement [
	<gtExample>
	| aCoderUIModel aMethodCoderElement |

	aCoderUIModel := self expandedMethodCoder.
	aMethodCoderElement := aCoderUIModel asElement.
	
	^ aMethodCoderElement
]

{ #category : #'instance creation' }
GtCoderWorkWithMethodCoderHowToGuide >> uiModelForCoder [
	<gtExample>
	| aCoderUIModel |
	
	aCoderUIModel := self coderForMethod asCoderUIModel.

	self assert: aCoderUIModel focused equals: false.
	self assert: aCoderUIModel expanded equals: false.
	
	^ aCoderUIModel
]
