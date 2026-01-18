Class {
	#name : #GtSourceCoderExpandedContentElement,
	#superclass : #GtSourceCoderContentElement,
	#instVars : [
		'editorElement',
		'actions',
		'tags'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #accessing }
GtSourceCoderExpandedContentElement >> actions [
	^ actions
]

{ #category : #'focus requesting' }
GtSourceCoderExpandedContentElement >> focusTarget [
	^ editorElement focusTarget
]

{ #category : #initialization }
GtSourceCoderExpandedContentElement >> initialize [
	super initialize.

	editorElement := self newEditorElement.
	actions := self newActionsElement.

	actions visibility: BlVisibility hidden.

	self
		addAptitude: (BrStyleCommonAptitude new
				when: BlElementState hovered & BlElementState focused not
					style: [ :aStyle | 
						aStyle
							do: [ :aWidget | actions visibility: BlVisibility visible ]
							after: [ :aWidget | actions visibility: BlVisibility hidden ] ];
				focused: [ :aStyle | 
					aStyle
						do: [ :aWidget | actions visibility: BlVisibility visible ]
						after: [ :aWidget | actions visibility: BlVisibility hidden ] ]).

	self
		addChildren: {editorElement.
				actions}.
	self addAptitude: (BrLayoutResizerAptitude new inherit: editorElement)
]

{ #category : #'instance creation' }
GtSourceCoderExpandedContentElement >> newActionsElement [
	^ GtSourceCoderActionsElement new
		margin: (BlInsets top: 5);
		id: #actions;
		yourself
]

{ #category : #'instance creation' }
GtSourceCoderExpandedContentElement >> newEditorElement [
	^ GtSourceCoderElement new
]

{ #category : #'api - textual coder view model' }
GtSourceCoderExpandedContentElement >> onTextualCoderViewModelChanged [
	super onTextualCoderViewModelChanged.

	actions coderViewModel: textualCoderViewModel.
	editorElement textualCoderViewModel: textualCoderViewModel
]

{ #category : #initialization }
GtSourceCoderExpandedContentElement >> showScrollbars [
	editorElement showScrollbars
]
