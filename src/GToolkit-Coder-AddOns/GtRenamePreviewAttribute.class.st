Class {
	#name : #GtRenamePreviewAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'text',
		'originalAttributes',
		'renameAction',
		'renameEditor'
	],
	#category : #'GToolkit-Coder-AddOns-Inline rename'
}

{ #category : #accessing }
GtRenamePreviewAttribute >> action: aRenameAction [
	renameAction := aRenameAction
]

{ #category : #accessing }
GtRenamePreviewAttribute >> additionalAttributes [
	^ {
		BlTextDecorationAttribute new underline color: BrGlamorousColors textHighlightColor
	}
]

{ #category : #accessing }
GtRenamePreviewAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	| editor |

	renameEditor := BrEditorElement new.
	renameEditor
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ].
	editor := BrTextEditorModel new
		text: text;
		yourself.

	renameEditor editor: editor.
	^ renameEditor
]

{ #category : #accessing }
GtRenamePreviewAttribute >> editor [
	^ renameEditor editor
]

{ #category : #initialization }
GtRenamePreviewAttribute >> initialize [
	super initialize.

	self beNotOverwritableByStyler.
	self beReplace
]

{ #category : #testing }
GtRenamePreviewAttribute >> isEditorAttribute [
	^ false
]

{ #category : #accessing }
GtRenamePreviewAttribute >> text [
	^ text
]

{ #category : #accessing }
GtRenamePreviewAttribute >> text: blText [
	text := blText asString asRopedText.
	originalAttributes isNil
		ifTrue:
			[ originalAttributes := (blText isEmpty ifTrue: [ #() ] ifFalse: [ blText attributesAt: 1 ])
				reject: [ :each | each isEventHandler ] ].
	text attributes: originalAttributes , self additionalAttributes
]

{ #category : #accessing }
GtRenamePreviewAttribute >> uninstallEventHandlers [
]

{ #category : #accessing }
GtRenamePreviewAttribute >> updateText: blText [
	self text: blText.
	renameEditor notNil
		ifTrue: [ renameEditor editor text: text ]
]
