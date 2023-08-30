Class {
	#name : #GtRenameEditor,
	#superclass : #BrEditableLabel,
	#category : #'GToolkit-Coder-AddOns-Inline rename'
}

{ #category : #accessing }
GtRenameEditor >> initialize [
	super initialize.
	self userData at: #isRefactoringEditor put: true.
	self
		when: BlFocusEvent
		do: [ :anEvent | 
			self viewModel mode class = BrTextEditorReadonlyWithoutSelectionMode
				ifTrue: [ self switchToEditor ] ]
]
