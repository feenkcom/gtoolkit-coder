Class {
	#name : 'GtCommandExamples',
	#superclass : 'Object',
	#category : 'GToolkit-VariableBindings-Examples'
}

{ #category : 'code evaluation' }
GtCommandExamples >> evaluateSourceCodeCommand [
	<gtExample>
	<label: 'Evaluate source code command'>
	| aCommand |
	aCommand := GtEvaluateSourceCodeCommand new.
	self assert: aCommand sourceCode isString.
	self assert: aCommand bindingStrategy notNil.
	self assert: aCommand result isNil.
	self assert: aCommand receiver isNil.
	^ aCommand
]

{ #category : 'code evaluation' }
GtCommandExamples >> executeDefaultSourceCode [
	<gtExample>
	<label: 'Evaluate a default source code command'>
	| aCommand |
	aCommand := self evaluateSourceCodeCommand.
	aCommand execute.
	self assert: aCommand result isNil.
	^ aCommand
]

{ #category : 'code evaluation' }
GtCommandExamples >> executeSourceCode [
	<gtExample>
	<label: 'Evaluate a source code'>
	| aCommand |
	aCommand := self evaluateSourceCodeCommand.
	aCommand sourceCode: '4 factorial'.
	aCommand execute.
	self assert: aCommand result equals: 24.
	^ aCommand
]

{ #category : 'code evaluation' }
GtCommandExamples >> executeSourceCodeWithUndefinedVariable [
	<gtExample>
	<label: 'Evaluate a source code with undefined variable'>
	| aCommand aWarning |
	aCommand := self evaluateSourceCodeCommand.
	aCommand sourceCode: 'aValue := 4 factorial'.
	[ aCommand execute ] 
		on: OCUndeclaredVariableWarning 
		do: [ :theWarning | aWarning := theWarning ].
	self assert: aWarning notNil.
	self assert: aWarning class equals: OCUndeclaredVariableWarning.
	self assert: aWarning node name equals: #aValue.
	self assert: aCommand result isNil.
	^ aCommand
]

{ #category : 'code evaluation' }
GtCommandExamples >> executeSourceCodeWithUndefinedVariableUsingPlaygroundBindings [
	<gtExample>
	<label: 'Evaluate a source code with undefined variable using playground bindings'>
	| aCommand |
	aCommand := self evaluateSourceCodeCommand.
	aCommand sourceCode: 'aValue := 4 factorial'.
	aCommand variableBindings: GtSnippetBindings new.
	aCommand execute.
	self assert: aCommand result equals: 24.
	self assert: (aCommand variableBindings bindingOf: #aValue) notNil.
	self assert: (aCommand variableBindings bindingOf: #aValue) value equals: 24.
	^ aCommand
]

{ #category : 'code evaluation' }
GtCommandExamples >> executeUndefinedVariable [
	<gtExample>
	<label: 'Evaluate a source code'>
	| aCommand aVariable |
	aCommand := self evaluateSourceCodeCommand.
	aCommand variableBindings: self playgroundBindings.
	aCommand sourceCode: 'aValue := 42'.
	aCommand execute.
	self assert: aCommand result equals: 42.
	self assert: aCommand variableBindings notNil.
	aVariable := aCommand variableBindings bindingOf: #aValue.
	self assert: aVariable notNil.
	self assert: aVariable value equals: 42.
	^ aCommand
]

{ #category : 'code evaluation' }
GtCommandExamples >> playgroundBindings [
	<gtExample>
	^ GtSnippetBindings new
]
