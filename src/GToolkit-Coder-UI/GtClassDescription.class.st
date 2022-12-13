Class {
	#name : #GtClassDescription,
	#superclass : #GtTraitDescription,
	#instVars : [
		'superclassName',
		'classVars',
		'pools'
	],
	#category : #'GToolkit-Coder-UI-Forms - Models'
}

{ #category : #accessing }
GtClassDescription >> classVars [

	^ classVars
]

{ #category : #accessing }
GtClassDescription >> classVars: anObject [

	classVars := anObject
]

{ #category : #accessing }
GtClassDescription >> classVarsDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Class vars';
		priority: 7;
		accessor: #classVars;
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
GtClassDescription >> initialize [
	super initialize.

	self className: 'NameOfSubclass'.
	self superclassName: 'Object'.

	classVars := OrderedCollection new.
	pools := OrderedCollection new
]

{ #category : #accessing }
GtClassDescription >> pools [

	^ pools
]

{ #category : #accessing }
GtClassDescription >> pools: anObject [

	pools := anObject
]

{ #category : #accessing }
GtClassDescription >> poolsDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Pools';
		priority: 7;
		accessor: #pools;
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
GtClassDescription >> superclassDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Superclass';
		priority: 2;
		accessor: #superclassName;
		blocCompletion: [ GtStringsCompletionStrategy new
				completions: (GtPrefixTree withAll: (Smalltalk allClasses collect: #name)) ];
		addCondition: [ :aValue | (Smalltalk classNamed: aValue trim) isNotNil ]
			labelled: 'Unknown class'
]

{ #category : #accessing }
GtClassDescription >> superclassName [

	^ superclassName
]

{ #category : #accessing }
GtClassDescription >> superclassName: anObject [

	superclassName := anObject
]
