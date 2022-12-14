Class {
	#name : #GtTraitDescription,
	#superclass : #Object,
	#instVars : [
		'className',
		'traits',
		'slots'
	],
	#category : #'GToolkit-Coder-UI-Forms - Models'
}

{ #category : #accessing }
GtTraitDescription >> className [
	^ className
]

{ #category : #accessing }
GtTraitDescription >> className: anObject [
	className := anObject
]

{ #category : #accessing }
GtTraitDescription >> defaultName [
	^ 'TNameOfTrait'
]

{ #category : #initialization }
GtTraitDescription >> initialize [
	className := self defaultName.
	traits := OrderedCollection new.
	slots := OrderedCollection new
]

{ #category : #magritte }
GtTraitDescription >> nameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Name';
		priority: 1;
		accessor: #className;
		blocCompletion: [ GtStringsCompletionStrategy new
				completions: (GtPrefixTree withAll: (Smalltalk allClasses collect: #name)) ];
		addCondition: [ :aValue | (Smalltalk classNamed: aValue trim) isNil ]
			labelled: 'Name is already taken';
		addCondition: [ :aValue | aValue first isUppercase ]
			labelled: 'First character must be uppercase';
		addCondition: [ :aValue | aValue isAllAlphaNumerics ]
			labelled: 'Class name must be alphanumeric'
]

{ #category : #accessing }
GtTraitDescription >> slots [

	^ slots
]

{ #category : #accessing }
GtTraitDescription >> slots: anObject [

	slots := anObject
]

{ #category : #accessing }
GtTraitDescription >> slotsDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Slots';
		priority: 5;
		accessor: #slots;
		blocListStencil: [ :aMemento :aDescription :aForm | 
			| aTagger |
			aTagger := BrTagger new.
			aTagger
				margin: ((BlInsets left: 7) withBottom: 4);
				hMatchParent;
				vFitContent.
			aForm hMatchParent.
			aTagger
				aptitude: (BrGlamorousTaggerEditableAptitude new
						margin: (BlInsets right: 5);
						tagLabel: [ :aTag | 
							BrEditableLabel new
								text: (aDescription displayStringFor: aTag name);
								aptitude: (BrGlamorousEditableLabelAptitude new
										glamorousCodeFont;
										defaultForeground: Color black;
										fontSize: 10);
								whenKey: BlKeyCombination primaryB
									labelDo: [ :aShortcutEvent :aShortcut | aTagger phlow spawnObject: aTag name ] ]).
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
						using: aDescription ].
			aTagger
				withAsyncSinkDo: [ :anElementSink | 
					anElementSink
						sink: AsyncPeakSink new;
						whenUpdate: [ :theTagger :aSink | 
							| theValues |
							theValues := aSink value currentValue.
							theTagger namedTags: theValues ].
					(aMemento readObservableValueUsing: aDescription) observe: anElementSink ] ]
]

{ #category : #accessing }
GtTraitDescription >> traits [

	^ traits
]

{ #category : #accessing }
GtTraitDescription >> traits: anObject [

	traits := anObject
]

{ #category : #accessing }
GtTraitDescription >> traitsDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Traits';
		priority: 5;
		accessor: #traits;
		blocListStencil: [ :aMemento :aDescription :aForm | 
			| aTagger |
			aTagger := BrTagger new.
			aTagger
				margin: ((BlInsets left: 7) withBottom: 4);
				hMatchParent;
				vFitContent.
			aForm hMatchParent.
			aTagger
				aptitude: (BrGlamorousTaggerEditableAptitude new
						margin: (BlInsets right: 5);
						tagLabel: [ :aTag | 
							BrEditableLabel new
								text: (aDescription displayStringFor: aTag name);
								aptitude: (BrGlamorousEditableLabelAptitude new
										glamorousCodeFont;
										defaultForeground: Color black;
										fontSize: 10);
								whenKey: BlKeyCombination primaryB
									labelDo: [ :aShortcutEvent :aShortcut | aTagger phlow spawnObject: aTag name ] ]).
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
						using: aDescription ].
			aTagger
				withAsyncSinkDo: [ :anElementSink | 
					anElementSink
						sink: AsyncPeakSink new;
						whenUpdate: [ :theTagger :aSink | 
							| theValues |
							theValues := aSink value currentValue.
							theTagger namedTags: theValues ].
					(aMemento readObservableValueUsing: aDescription) observe: anElementSink ] ]
]
