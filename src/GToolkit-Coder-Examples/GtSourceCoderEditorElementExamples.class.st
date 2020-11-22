Class {
	#name : #GtSourceCoderEditorElementExamples,
	#superclass : #GtCoderByScripterExamples,
	#category : #'GToolkit-Coder-Examples-Source Coder - UI'
}

{ #category : #'example - instance creation' }
GtSourceCoderEditorElementExamples >> editorForExampleMethodCoder [
	<gtExample>
	| aMethodCoder aMethodCoderUIModel anEditorElement |
	
	aMethodCoder := GtMethodCoderExamples new forExampleMethodCoder.
	aMethodCoderUIModel := aMethodCoder asCoderUIModel.
	
	self assert: aMethodCoder addOns shouldBeUpdated.
	BlUseAsyncFeatures disableDuring: [ anEditorElement := GtSourceCoderEditorElement new sourceCoderUIModel: aMethodCoderUIModel ].
	self assert: aMethodCoder addOns shouldBeUpdated not.

	self assert: anEditorElement hasFocus not.
	self assert: anEditorElement padding equals: BlInsets empty.
	self assert: anEditorElement margin equals: BlInsets empty.
	self assert: anEditorElement text equals: aMethodCoder sourceText.

	^ anEditorElement
]
