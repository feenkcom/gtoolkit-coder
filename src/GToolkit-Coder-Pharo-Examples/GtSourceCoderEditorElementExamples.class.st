Class {
	#name : #GtSourceCoderEditorElementExamples,
	#superclass : #GtCoderByScripterExamples,
	#category : #'GToolkit-Coder-Pharo-Examples'
}

{ #category : #'example - instance creation' }
GtSourceCoderEditorElementExamples >> editorForExampleMethodCoder [
	<gtExample>
	| aMethodCoder aMethodCoderUIModel anEditorElement |
	
	aMethodCoder := GtPharoMethodCoderExamples new forExampleMethodCoder.
	aMethodCoderUIModel := aMethodCoder asCoderUIModel.
	
	self assert: aMethodCoderUIModel shouldAddOnsBeUpdated.
	BlUseAsyncFeatures disableDuring: [
		anEditorElement := GtSourceCoderEditorElement new
			textualCoderViewModel: aMethodCoderUIModel ].
	self assert: aMethodCoderUIModel shouldAddOnsBeUpdated not.

	self assert: anEditorElement hasFocus not.
	self assert: anEditorElement padding equals: BlInsets empty.
	self assert: anEditorElement margin equals: BlInsets empty.
	self assert: anEditorElement text characters equals: aMethodCoder sourceText characters.

	^ anEditorElement
]
