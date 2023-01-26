Class {
	#name : #GtCreationForm,
	#superclass : #Object,
	#instVars : [
		'onAccept',
		'packageAndTagName'
	],
	#category : #'GToolkit-Coder-UI-Forms - Models'
}

{ #category : #accessing }
GtCreationForm class >> componentName [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtCreationForm class >> priority [
	^ self subclassResponsibility
]

{ #category : #magritte }
GtCreationForm >> acceptAction [
	<magritteActionDescription>
	^ MAActionDescription new
		label: 'Accept';
		action: [ :aModel :aButton | 
			[ | aValue |
			aValue := self commit.
			onAccept ifNotNil: [ onAccept value: aValue ] ] on: Error do: #inspect ];
		beCommitAction
]

{ #category : #converting }
GtCreationForm >> asElement [
	| viewModel |
	viewModel := self asGtMagritteViewModel.
	"save action should be available even if unchanged"
	viewModel actions first
		installOn: [ :aModel :aButton :aMemento | 
			aButton
				withAsyncSinkDo: [ :anElementSink | 
					anElementSink
						sink: AsyncPeekSink new;
						whenUpdate: [ :theButton :aSink | 
							| aStatus |
							aStatus := aSink value.
							theButton enabled: aStatus isValid ].
					aMemento overallStatus observe: anElementSink ] ].
	^ viewModel asElement
]

{ #category : #callbacks }
GtCreationForm >> commit [
	^ self subclassResponsibility
]

{ #category : #callbacks }
GtCreationForm >> commitPackage [
	| aPackage |
	(RPackageOrganizer default includesPackageNamed: packageAndTagName packageName)
		ifTrue: [ aPackage := RPackageOrganizer default
					packageNamed: packageAndTagName packageName.
			^ packageAndTagName tagName
				ifEmpty: [ aPackage ]
				ifNotEmpty: [ :aTagName | aPackage classTagNamed: aTagName ifAbsent: [ aPackage addClassTag: aTagName ] ] ]
		ifFalse: [ aPackage := (RPackage named: packageAndTagName packageName)
					register.
			^ packageAndTagName tagName
				ifEmpty: [ aPackage ]
				ifNotEmpty: [ :aTagName | aPackage addClassTag: aTagName ] ]
]

{ #category : #accessing }
GtCreationForm >> ghostTextFor: aString [
	^ BrGhostTextAttribute
		for: (aString asRopedText glamorousCodeFont foreground: Color lightGray)
]

{ #category : #initialization }
GtCreationForm >> initialize [
	packageAndTagName := GtPackageAndTagName new
]

{ #category : #accessing }
GtCreationForm >> onAccept [

	^ onAccept
]

{ #category : #accessing }
GtCreationForm >> onAccept: anObject [

	onAccept := anObject
]

{ #category : #accessing }
GtCreationForm >> packageAndTagDescription [
	<magritteDescription>
	^ GtPackageAndTagDescription new
		label: 'Package';
		priority: 3;
		accessor: #packageAndTagName;
		textStyler: #glamorousCodeFont;
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

{ #category : #accessing }
GtCreationForm >> selectInNavigationModel: aNavigationModel anInstance: anInstance [
	^ aNavigationModel selectClass: anInstance
]

{ #category : #accessing }
GtCreationForm >> taggerStencilWithCompletion: aCompletionStrategy [
	^ [ :aMemento :aDescription :aForm | 
	| aTagger aTaggerAptitude |
	aTagger := BrTagger new.
	aTagger fitContent.
	aForm hMatchParent.
	aTagger
		aptitude: (aTaggerAptitude := GtCreationEditableTaggerAptitude new
					margin: (BlInsets right: 5);
					tagLabel: [ :aTag | 
						| aLabel |
						aLabel := BrEditableLabel new
								text: (aDescription displayStringFor: aTag name);
								aptitude: (BrGlamorousEditableLabelAptitude new glamorousCodeFont
										defaultForeground: Color black);
								whenKey: BlKeyCombination arrowRight
									editorDo: [ :anEvent | 
										anEvent target acceptEdition.
										aTaggerAptitude addTagCreatorElement ].
						aCompletionStrategy
							ifNotNil: [ (GtCompletionController on: aLabel strategy: aCompletionStrategy) install ].
						aLabel ]).
	aTagger
		when: BrTaggerAddTagRequest
		do: [ :aRequest | 
			aMemento
				write: ((aTagger tags collect: #name)
						add: aRequest tag name;
						yourself)
				using: aDescription ].
	aTagger
		when: BrTaggerRemoveTagRequest
		do: [ :aRequest | 
			aMemento
				write: ((aTagger tags collect: #name)
						remove: aRequest tag name;
						yourself)
				using: aDescription.
			aTaggerAptitude addTagCreatorElement ].
	aTagger
		withAsyncSinkDo: [ :anElementSink | 
			anElementSink
				sink: AsyncPeekSink new;
				whenUpdate: [ :theTagger :aSink | 
					| theValues |
					theValues := aSink value currentValue.
					theTagger namedTags: theValues ].
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
