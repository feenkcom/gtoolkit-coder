"
I hold the shortcut identifiers for coder-specific keyboard shortcuts. Core shortcuts defined in GToolkit-Coder-UI are stored as instance variables. Shortcuts from other packages (GToolkit-Debugger, GToolkit-GemStone-Lepiter, etc.) are stored via the extensible extraShortcutIdsByIdentifier mechanism inherited from BlShortcutIds, accessed via shortcutIdForIdentifier:.
"
Class {
	#name : #GtCoderShortcutIds,
	#superclass : #BlShortcutIds,
	#instVars : [
		'browseBehaviorShortcutId',
		'browseImplementorsShortcutId',
		'browseReferencesShortcutId',
		'compileItShortcutId',
		'debugShortcutId',
		'discardChangesShortcutId',
		'doItAndInspectAsynchronousShortcutId',
		'doItAndInspectSerializedShortcutId',
		'doItAndInspectShortcutId',
		'doItAsynchronousShortcutId',
		'doItShortcutId',
		'extractMethodShortcutId',
		'foldNoiseShortcutId',
		'formatShortcutId',
		'moveStatementDownShortcutId',
		'moveStatementUpShortcutId',
		'playAndInspectShortcutId',
		'playShortcutId',
		'printItShortcutId',
		'saveShortcutId',
		'searchTextShortcutId',
		'selectStatementDownShortcutId',
		'selectStatementUpShortcutId'
	],
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtCoderShortcutIds >> browseBehaviorShortcutId [
	^ browseBehaviorShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> browseImplementorsShortcutId [
	^ browseImplementorsShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> browseReferencesShortcutId [
	^ browseReferencesShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> compileItShortcutId [
	^ compileItShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> debugShortcutId [
	^ debugShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> discardChangesShortcutId [
	^ discardChangesShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> doItAndInspectAsynchronousShortcutId [
	^ doItAndInspectAsynchronousShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> doItAndInspectSerializedShortcutId [
	^ doItAndInspectSerializedShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> doItAndInspectShortcutId [
	^ doItAndInspectShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> doItAsynchronousShortcutId [
	^ doItAsynchronousShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> doItShortcutId [
	^ doItShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> extractMethodShortcutId [
	^ extractMethodShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> foldNoiseShortcutId [
	^ foldNoiseShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> formatShortcutId [
	^ formatShortcutId
]

{ #category : #initialization }
GtCoderShortcutIds >> initialize [
	super initialize.
	
	browseBehaviorShortcutId := BlShortcutId identifier: #CoderBrowseBehavior.
	browseImplementorsShortcutId := BlShortcutId identifier: #CoderBrowseImplementors.
	browseReferencesShortcutId := BlShortcutId identifier: #CoderBrowseReferences.
	compileItShortcutId := BlShortcutId identifier: #CoderCompileIt.
	debugShortcutId := BlShortcutId identifier: #CoderDebug.
	discardChangesShortcutId := BlShortcutId identifier: #CoderDiscardChanges.
	doItAndInspectAsynchronousShortcutId := BlShortcutId identifier: #CoderDoItAndInspectAsynchronous.
	doItAndInspectSerializedShortcutId := BlShortcutId identifier: #CoderDoItAndInspectSerialized.
	doItAndInspectShortcutId := BlShortcutId identifier: #CoderDoItAndInspect.
	doItAsynchronousShortcutId := BlShortcutId identifier: #CoderDoItAsynchronous.
	doItShortcutId := BlShortcutId identifier: #CoderDoIt.
	extractMethodShortcutId := BlShortcutId identifier: #CoderExtractMethod.
	foldNoiseShortcutId := BlShortcutId identifier: #CoderFoldNoise.
	formatShortcutId := BlShortcutId identifier: #CoderFormat.
	moveStatementDownShortcutId := BlShortcutId identifier: #CoderMoveStatementDown.
	moveStatementUpShortcutId := BlShortcutId identifier: #CoderMoveStatementUp.
	playAndInspectShortcutId := BlShortcutId identifier: #CoderPlayAndInspect.
	playShortcutId := BlShortcutId identifier: #CoderPlay.
	printItShortcutId := BlShortcutId identifier: #CoderPrintIt.
	saveShortcutId := BlShortcutId identifier: #CoderSave.
	searchTextShortcutId := BlShortcutId identifier: #CoderSearchText.
	selectStatementDownShortcutId := BlShortcutId identifier: #CoderSelectStatementDown.
	selectStatementUpShortcutId := BlShortcutId identifier: #CoderSelectStatementUp.
]

{ #category : #accessing }
GtCoderShortcutIds >> moveStatementDownShortcutId [
	^ moveStatementDownShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> moveStatementUpShortcutId [
	^ moveStatementUpShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> playAndInspectShortcutId [
	^ playAndInspectShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> playShortcutId [
	^ playShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> printItShortcutId [
	^ printItShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> saveShortcutId [
	^ saveShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> searchTextShortcutId [
	^ searchTextShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> selectStatementDownShortcutId [
	^ selectStatementDownShortcutId
]

{ #category : #accessing }
GtCoderShortcutIds >> selectStatementUpShortcutId [
	^ selectStatementUpShortcutId
]
