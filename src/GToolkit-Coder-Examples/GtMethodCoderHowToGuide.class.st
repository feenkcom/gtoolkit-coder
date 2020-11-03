"
!How to work with method coder
${class:GtMethodCoder}$ plays an important role in ${class:GtCoder}$ and ==Glamorous Toolkit==. It is a self sufficient molecula in the ecosystem of editors and can be embedded in various contexts. Method Coder is moldable and can be extended with the help of its ==add-on== mechanism.
An instance of the Method Coder doesn't have any knowledge of the UI state and is responsible for a low level method editing and refactoring. It can be created directly from a compiled method:
${example:GtMethodCoderHowToGuide>>#coderForMethod|codeExpanded=true}$
!!!How to expand/collapse/give focus?
See ${class:GtMethodCoderUIModelHowToGuide}$ for how to deal with method coder's UI model.
"
Class {
	#name : #GtMethodCoderHowToGuide,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-! HowTo'
}

{ #category : #'instance creation' }
GtMethodCoderHowToGuide >> coderForMethod [
	<gtExample>
	
	^ GtMethodCoder forMethod: GtBehaviorCoderDummyClass >> #instVarB:
]
