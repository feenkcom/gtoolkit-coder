Class {
	#name : #GtSourceCoderDoItAndInspectAsynchronousShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtSourceCoderDoItAndInspectAsynchronousShortcut >> description [
	^ 'Evaluates asynchronously the whole source code or just the selection and inspects the result.'
]

{ #category : #initialization }
GtSourceCoderDoItAndInspectAsynchronousShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryG
]

{ #category : #accessing }
GtSourceCoderDoItAndInspectAsynchronousShortcut >> name [
	^ 'Evaluate and inspect (asynchronous)'
]

{ #category : #evaluation }
GtSourceCoderDoItAndInspectAsynchronousShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	GtCoderExecutionContextVariable
		element: aBrEditorElement
		do: [ 
			aSourceCoderViewModel hasAsyncExecution
				ifTrue: [ 
					self inform: 'Cannot start async execution: already running' ]
				ifFalse: [
					aSourceCoderViewModel doItAndGoAsynchronous ] ]
]
