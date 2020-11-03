"
!Method Coder's UI model
When embedding a method coder as a UI component we often want to be able to specify (or save/restore) its initial UI state, such as expansion or a focus state. ${class:GtMethodCoderUIModel}$ fascilicates users with that ability.
!!How to create a UI model?
To create a default ${class:GtMethodCoderUIModel}$ for an existing instance of ${class:GtMethodCoder}$ it is enough to send a ${method:GtCoderModel>>#asCoderUIModel}$ message to that coder model. By default, the method coder is expanded and does not have a focus:
${example:GtMethodCoderUIModelHowToGuide>>#uiModelForCoder|codeExpanded=true}$
!!How to expand/collapse it?
Users may choose to visually expand a method coder:
${example:GtMethodCoderUIModelHowToGuide>>#expandedMethodCoder|codeExpanded=true|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=140}$
or collapse it:
${example:GtMethodCoderUIModelHowToGuide>>#collapsedMethodCoder|codeExpanded=true|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=95}$
!!How to give it focus?
Or also give it a focus by default:
${example:GtMethodCoderUIModelHowToGuide>>#expandedAndFocusedMethodCoder|codeExpanded=true|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=140}$
"
Class {
	#name : #GtMethodCoderUIModelHowToGuide,
	#superclass : #GtMethodCoderHowToGuide,
	#category : #'GToolkit-Coder-Examples-! HowTo'
}

{ #category : #'examples - method coder' }
GtMethodCoderUIModelHowToGuide >> collapsedMethodCoder [
	<gtExample>
	| aCoderUIModel |

	aCoderUIModel := self uiModelForCoder.
	aCoderUIModel expanded: false.
	
	^ aCoderUIModel
]

{ #category : #'examples - method coder' }
GtMethodCoderUIModelHowToGuide >> expandedAndFocusedMethodCoder [
	<gtExample>
	| aCoderUIModel |

	aCoderUIModel := self expandedMethodCoder.
	aCoderUIModel focused: true.
	
	^ aCoderUIModel
]

{ #category : #'examples - method coder' }
GtMethodCoderUIModelHowToGuide >> expandedAndFocusedMethodCoderElement [
	<gtExample>
	| aCoderUIModel aMethodCoderElement |

	aCoderUIModel := self expandedAndFocusedMethodCoder.
	aMethodCoderElement := aCoderUIModel asElement.
	
	self assert: aMethodCoderElement isExpanded equals: true.
	self assert: aMethodCoderElement hasFocus equals: true.
	
	^ aMethodCoderElement
]

{ #category : #'examples - method coder' }
GtMethodCoderUIModelHowToGuide >> expandedMethodCoder [
	<gtExample>
	| aCoderUIModel |

	aCoderUIModel := self uiModelForCoder.
	aCoderUIModel expanded: true.
	
	^ aCoderUIModel
]

{ #category : #'examples - method coder' }
GtMethodCoderUIModelHowToGuide >> expandedMethodCoderElement [
	<gtExample>
	| aCoderUIModel aMethodCoderElement |

	aCoderUIModel := self expandedMethodCoder.
	aMethodCoderElement := aCoderUIModel asElement.
	
	^ aMethodCoderElement
]

{ #category : #'instance creation' }
GtMethodCoderUIModelHowToGuide >> uiModelForCoder [
	<gtExample>
	| aCoderUIModel |
	
	aCoderUIModel := self coderForMethod asCoderUIModel.

	self assert: aCoderUIModel focused equals: false.
	self assert: aCoderUIModel expanded equals: true.
	
	^ aCoderUIModel
]
