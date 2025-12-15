Class {
	#name : #GtSourceCoderDoItAndInspectSerializedShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : 'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderDoItAndInspectSerializedShortcut >> description [
	^ 'Evaluates the whole source code or just the selection and inspects the serialized result.'
]

{ #category : #initialization }
GtSourceCoderDoItAndInspectSerializedShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryShiftG
]

{ #category : #accessing }
GtSourceCoderDoItAndInspectSerializedShortcut >> name [
	^ 'Evaluate and inspect serialized'
]

{ #category : #evaluation }
GtSourceCoderDoItAndInspectSerializedShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	GtCoderExecutionContextVariable
		element: aBrEditorElement
		do: [ aSourceCoderViewModel doItAndGoSerialized ]
]
