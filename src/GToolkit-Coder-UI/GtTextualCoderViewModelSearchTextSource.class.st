Class {
	#name : #GtTextualCoderViewModelSearchTextSource,
	#superclass : #BrEditorSearchTextSource,
	#instVars : [
		'textualCoderViewModel'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model'
}

{ #category : #accessing }
GtTextualCoderViewModelSearchTextSource >> editorModel [
	"Return an editor model for which the found patterns, e.g, substrings, are marked"

	<return: #BrTextEditorModel or: nil>
	^ 'self subclassResponsibility'
]

{ #category : #accessing }
GtTextualCoderViewModelSearchTextSource >> element [
	"Return an element to which actions, e.g., background computation can be hooked"

	<return: #BlElement or: nil>
	^ nil
]

{ #category : #testing }
GtTextualCoderViewModelSearchTextSource >> hasText [
	<return: #Boolean>
	^ self text isNotNil
]

{ #category : #testing }
GtTextualCoderViewModelSearchTextSource >> hasVisibleText [
	^ self visibleText isNotNil
]

{ #category : #accessing }
GtTextualCoderViewModelSearchTextSource >> text [
	"Return current editor text"

	<return: #BlText or: nil>
	| anAnnouncement |
	anAnnouncement := GtTextualCoderViewModelSearchTextGetTextAndVisibleTextAnnouncement new
			textualCoderViewModel: textualCoderViewModel.
	textualCoderViewModel announce: anAnnouncement.
	^ anAnnouncement text
]

{ #category : #accessing }
GtTextualCoderViewModelSearchTextSource >> textualCoderViewModel [
	^ textualCoderViewModel
]

{ #category : #accessing }
GtTextualCoderViewModelSearchTextSource >> textualCoderViewModel: anObject [
	textualCoderViewModel := anObject
]

{ #category : #updating }
GtTextualCoderViewModelSearchTextSource >> updateText: aStyledText [
	"Integrate new styled text to the existing editor's text.
	Return true if the integration happened, false otherwise.
	Note: Must be called from a UI process."

	<return: #Boolean>
	| anAnnouncement |
	anAnnouncement := GtTextualCoderViewModelSearchTextUpdateTextAnnouncement new
			textualCoderViewModel: textualCoderViewModel;
			styledText: aStyledText.
	textualCoderViewModel announce: anAnnouncement.
	^ anAnnouncement isUpdated
]

{ #category : #accessing }
GtTextualCoderViewModelSearchTextSource >> visibleText [
	"Return current editor visible text"

	<return: #BlText or: nil>
	| anAnnouncement |
	anAnnouncement := GtTextualCoderViewModelSearchTextGetTextAndVisibleTextAnnouncement new
			textualCoderViewModel: textualCoderViewModel.
	textualCoderViewModel announce: anAnnouncement.
	^ anAnnouncement visibleText
]
