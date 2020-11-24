"
I am a ${class:DynamicVariable}$.
I hold a ${class:GtCoderExecutionContext}$ as a ${class:Process}$ specific value.
I am used to pass an execution context information that can be requested, for example to display some information to user.
!! Usage
!!! Initializing Execution Context
To initialize context using a ${class:BlElement}$, use ${method:GtCoderExecutionContextVariable class>>#element:do:|label=#selector|expanded=true}$ class-side method:
!!! Obtaining Execution Context
To obtain the execution context, use ${method:ProcessSpecificVariable class>>#value|label=#selector|expanded=true}$ class-side method:
!!! Default Execution Context
If the execution context is not initialized, I return a ${method:GtCoderExecutionContextVariable>>#default|label=#selector|expanded=true}$ one:

"
Class {
	#name : #GtCoderExecutionContextVariable,
	#superclass : #DynamicVariable,
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #'api - execution' }
GtCoderExecutionContextVariable class >> element: anElement do: aBlock [
	"Initialize a Bloc UI execution context using the element and evaluate the block"
	| aContext |
	aContext := self newContextWithElement: anElement.
	^ self
		value: aContext
		during: aBlock
]

{ #category : #testing }
GtCoderExecutionContextVariable class >> isInheritable [
	^true
]

{ #category : #'private - instance creation' }
GtCoderExecutionContextVariable class >> newContextWithElement: anElement [
	anElement spaceDo: [ :aSpace | 
		^ GtCoderUIExecutionContext new
			spaceId: aSpace id ].
	^ GtCoderDefaultExecutionContext default
]

{ #category : #accessing }
GtCoderExecutionContextVariable >> default [
	^ GtCoderDefaultExecutionContext default
]
