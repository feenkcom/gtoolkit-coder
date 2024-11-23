Class {
	#name : #GtCoderPackagesTreeRenameEditor,
	#superclass : #GtCoderListEmbeddedRenameEditorElement,
	#category : #'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #'as yet unclassified' }
GtCoderPackagesTreeRenameEditor >> createCompleterStrategy [
	^ GtMethodProtocolCompletionStrategy new
]

{ #category : #'as yet unclassified' }
GtCoderPackagesTreeRenameEditor >> itemLabelOf: aPackage [
	^ aPackage name
]
