Class {
	#name : #GtCreationForm,
	#superclass : #Object,
	#instVars : [
		'onAccept',
		'packageAndTagName',
		'onElementCreated',
		'onReset'
	],
	#category : #'GToolkit-Coder-UI-Forms - Models'
}

{ #category : #accessing }
GtCreationForm class >> componentName [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtCreationForm class >> isAdditionForm [
	^ true
]

{ #category : #accessing }
GtCreationForm class >> priority [
	^ self subclassResponsibility
]

{ #category : #converting }
GtCreationForm >> asElement [
	| viewModel |
	viewModel := self asGtMagritteViewModel focusFirstInputField.
	self onElementCreated
		ifNotNil: [ :aCallback | viewModel onElementCreated: aCallback ].
	^ viewModel asElement
]

{ #category : #callbacks }
GtCreationForm >> commit [
	^ self subclassResponsibility
]

{ #category : #callbacks }
GtCreationForm >> commitPackage [
	| aPackage |
	(self packageOrganizer includesPackageNamed: packageAndTagName packageName)
		ifTrue: [ 
			aPackage := self packageOrganizer
				packageNamed: packageAndTagName packageName.
			^ packageAndTagName tagName
				ifEmpty: [ aPackage ]
				ifNotEmpty: [ :aTagName | 
					aPackage 
						tagNamed: aTagName 
						ifAbsent: [ aPackage addClassTag: aTagName ] ] ]
		ifFalse: [ 
			aPackage := (Package named: packageAndTagName packageName).
			self 
				forPharo12AndNewer: [
					self class packageOrganizer addPackage: aPackage] 
				forPharo11: [
					aPackage register ].
			^ packageAndTagName tagName
				ifEmpty: [ aPackage ]
				ifNotEmpty: [ :aTagName | aPackage addClassTag: aTagName ] ]
]

{ #category : #'api - initialization' }
GtCreationForm >> fillFormWithClass: aClass [
	
]

{ #category : #accessing }
GtCreationForm >> ghostTextFor: aString [
	^ BrGhostTextAttribute
		for: (aString asRopedText glamorousFormEditorCodeFontAndSize foreground: Color lightGray)
]

{ #category : #accessing }
GtCreationForm >> hasPackageAndTag [
	^ true
]

{ #category : #initialization }
GtCreationForm >> initialize [
	packageAndTagName := GtPackageAndTagName new
]

{ #category : #magritte }
GtCreationForm >> magritteAcceptAction [
	<magritteActionDescription>
	^ super magritteAcceptAction
		label: 'Create';
		onSuccessCallback: (GtMagritteCallback new
				action: [ :aModel :aButton :aMemento :aDescription | 
					[ | aClass |
					aClass := self secureCommit.
					onAccept ifNotNil: [ onAccept value: aClass ] ] 
						on: Error do: #debug ]);
		beEnabledOnValidOverallStatus
]

{ #category : #magritte }
GtCreationForm >> magritteCancelAction [
	<magritteActionDescription>
	^ super magritteCancelAction
		onSuccessCallback: (GtMagritteCallback new
				action: [ :aModel :aButton :aMemento :aDescription | 
					[ onReset ifNotNil: [ onReset value ] ] 
						on: Error do: #debug ]);
		beAlwaysEnabled
]

{ #category : #accessing }
GtCreationForm >> onAccept [

	^ onAccept
]

{ #category : #accessing }
GtCreationForm >> onAccept: aBlock [

	onAccept := aBlock
]

{ #category : #accessing }
GtCreationForm >> onElementCreated [
	^ onElementCreated
]

{ #category : #accessing }
GtCreationForm >> onElementCreated: aBlock [
	onElementCreated := aBlock
]

{ #category : #accessing }
GtCreationForm >> onReset [
	^ onReset
]

{ #category : #accessing }
GtCreationForm >> onReset: aBlock [
	onReset := aBlock
]

{ #category : #accessing }
GtCreationForm >> packageAndTagDescription [
	<magritteDescription>
	^ GtPackageAndTagDescription new
		label: 'Package';
		priority: 3;
		accessor: #packageAndTagName;
		editorAptitude: [ BrGlamorousRegularEditorAptitude new glamorousFormEditorCodeFontAndSize ];
		labelAptitude: [ BrGlamorousLabelAptitude new glamorousFormLabelStyle ];
		beRequired
]

{ #category : #accessing }
GtCreationForm >> packageAndTagName [

	^ packageAndTagName
]

{ #category : #accessing }
GtCreationForm >> packageAndTagName: anObject [

	packageAndTagName := anObject
]

{ #category : #callbacks }
GtCreationForm >> secureCommit [
	"Subclasses may use a mutex to prevent race conditions."

	^ self commit
]

{ #category : #accessing }
GtCreationForm >> selectInNavigationModel: aNavigationModel anInstance: anInstance [
	aNavigationModel selectPackage: anInstance package.
	
	(anInstance package tags reject: [ :aTag | aTag isRoot])
		ifNotEmpty: [
			anInstance packageTag ifNotNil:  [ :aPackageTag |
				aPackageTag isRoot ifFalse: [ 
					anInstance tags ifNotEmpty: [ :anInstanceTags |
						aNavigationModel
							selectPackageTag: (anInstance package 
								tagNamed: anInstanceTags first) ] ] ] ].

	aNavigationModel selectClass: anInstance
]

{ #category : #accessing }
GtCreationForm >> taggerStencilWithCompletion: aCompletionStrategy contextMenuContentBlock: aContextMenuContentBlock [
	^ self
		taggerStencilWithCompletion: aCompletionStrategy
		contextMenuContentBlock: aContextMenuContentBlock
		contextMenuBlock: nil
]

{ #category : #accessing }
GtCreationForm >> taggerStencilWithCompletion: aCompletionStrategy contextMenuContentBlock: aContextMenuContentBlock contextMenuBlock: aContextMenuBlock [
	"aContextMenuContentBlock returns an element.
	aContextMenuBlock returns a BrMenu or nil."

	^ [ :aMemento :aDescription :aForm | 
	| aTagger aTaggerAptitude |
	aTagger := BrTagger new hFitContentLimited.
	aForm hMatchParent.
	aTagger
		padding: (BlInsets top: -2 bottom: 5);
		clipChildren: false;
		aptitude: (aTaggerAptitude := GtCreationEditableTaggerAptitude new
					margin: (BlInsets
							top: 0
							bottom: 3
							left: 0
							right: 5);
					tagLabel: [ :aTag | 
						| aLabel |
						aLabel := BrEditor new fitContent
								text: (aDescription displayStringFor: aTag name);
								aptitude: (BrGlamorousEditableLabelAptitude new glamorousFormEditorCodeFontAndSize
										defaultForeground: Color black);
								addShortcut: (BlShortcutWithAction new
										name: 'Move to previous form item';
										description: 'Moves to the previous form item. If none is found, we cycle back to the last.';
										combination: BlKeyCombination shiftTab;
										action: [ :anEvent | 
											BlFocusFinder new
												direction: BlFocusSearchDirectionBackward new;
												root: aForm;
												referenceElement: anEvent currentTarget;
												nextFocusDo: #requestFocus ifNone: [  ] ]);
								addShortcut: (BlShortcutWithAction new
										name: 'Move to next form item';
										description: 'Moves to the next form item. If none is found, we cycle back to the first.';
										combination: (BlKeyCombination tab or: BlKeyCombination enter);
										action: [ :anEvent | 
											BlFocusFinder new
												direction: BlFocusSearchDirectionForward new;
												root: aForm;
												referenceElement: anEvent currentTarget;
												nextFocusDo: #requestFocus ifNone: [  ] ]).

						aDescription blocShortcuts
							ifNotNil: [ :aBlockReturningCollection | 
								aBlockReturningCollection value
									do: [ :aShortcut | aLabel addShortcut: aShortcut ] ].

						aCompletionStrategy
							ifNotNil: [ (GtCompletionController on: aLabel strategy: aCompletionStrategy) install ].
						aContextMenuBlock
							ifNil: [ aContextMenuContentBlock
									ifNotNil: [ aLabel
											addAptitude: (BrGlamorousWithExplicitContextMenuAptitude
													content: [ aContextMenuContentBlock
															value: aTag name
															value: aLabel
															value: aMemento ]) ] ]
							ifNotNil: [ aLabel
											addAptitude: (BrGlamorousWithExplicitContextMenuAptitude
													menu: [ aContextMenuBlock
															value: aTag name
															value: aLabel
															value: aMemento ]) ].
						aLabel ]).
	aTagger
		when: BrTaggerAddTagRequest
		do: [ :aRequest | 
			| aValue |
			aRequest currentTarget addTag: aRequest tag.
			aValue := aTagger tags collect: #name thenSelect: #isNotEmpty.

			GtMagritteBuilderUtility
				write: aValue asArray
				using: aDescription
				memento: aMemento
				element: aTagger ].
	aTagger
		when: BrTaggerRenameTagRequest
		do: [ :aRequest | 
			(aRequest tag name = aRequest newName) not
				ifTrue: [ | aValue |
					aRequest currentTarget renameTag: aRequest tag to: aRequest newName.
					aValue := aTagger tags collect: #name.

					GtMagritteBuilderUtility
						write: aValue asArray
						using: aDescription
						memento: aMemento
						element: aTagger ] ].
	aTagger
		when: BrTaggerRemoveTagRequest
		do: [ :aRequest | 
			| aValue |
			aRequest currentTarget removeTag: aRequest tag.
			aValue := aTagger tags collect: #name.

			GtMagritteBuilderUtility
				write: aValue asArray
				using: aDescription
				memento: aMemento
				element: aTagger ].
	aTagger
		withAsyncSinkDo: [ :anElementSink | 
			anElementSink
				sink: AsyncPeekSink new;
				whenUpdate: [ :theTagger :aSink | 
					| theValues |
					(theTagger tags isEmpty or: [ aSink value isChanged not ])
						ifTrue: [ theValues := aSink value currentValue.
							theTagger namedTags: theValues ] ].
			(aMemento readObservableValueUsing: aDescription) observe: anElementSink ].
	GtMagritteBuilderUtility
		newValidationContainerWith: aTagger
		memento: aMemento
		using: aDescription ]
]

{ #category : #accessing }
GtCreationForm >> toolFor: anInstance [
	^ GtClassCoderTool forClass: anInstance
]
