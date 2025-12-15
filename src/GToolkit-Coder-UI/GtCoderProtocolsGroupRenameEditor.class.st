Class {
	#name : #GtCoderProtocolsGroupRenameEditor,
	#superclass : #GtCoderListEmbeddedRenameEditorElement,
	#category : 'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #'as yet unclassified' }
GtCoderProtocolsGroupRenameEditor >> createCompleterStrategy [
	^ GtMethodProtocolCompletionStrategy new
]

{ #category : #'as yet unclassified' }
GtCoderProtocolsGroupRenameEditor >> itemLabelOf: aProtocol [
	^ aProtocol name
]
