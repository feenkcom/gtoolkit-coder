Extension { #name : #GtMagritteModelExamples }

{ #category : #'*GToolkit-Coder-Examples' }
GtMagritteModelExamples >> simpleBaselineDescription [
	<gtExample>
	<return: #MAPriorityContainer>
	^ MAPriorityContainer
		withAll: {MAStringDescription new
					accessor: (MADictionaryAccessor key: #baseline);
					beAlwaysEditable;
					blocCompletion: [ GtClassesCompletionStrategy new ];
					beRequired;
					addCondition: [ :aValue | aValue beginsWith: 'BaselineOf' ]
						labelled: 'Baseline name must begin with BaselineOf';
					addCondition: [ :aValue | (Smalltalk globals includesKey: aValue asSymbol) not ]
						labelled: 'Baseline name must be a non-existent class';
					comment: 'Baseline name'}
]

{ #category : #'*GToolkit-Coder-Examples' }
GtMagritteModelExamples >> simpleBaselinesDescription [
	<gtExample>
	<return: #MAPriorityContainer>
	^ MAPriorityContainer
		withAll: {MAToManyRelationDescription new
					label: 'Baselines';
					classes: {String};
					accessor: (MADictionaryAccessor key: #baselines);
					blocListStencil: [ :aMemento :aDescription :aForm | 
						| aTagger |
						aTagger := BrTagger new.
						aTagger
							hMatchParent;
							vFitContent.
						aForm hMatchParent.
						aTagger
							aptitude: (BrGlamorousTaggerEditableAptitude new
									tagLabel: [ :aTag | 
										| aLabel |
										aLabel := BrEditableLabel new
												text: aTag name;
												aptitude: (BrGlamorousEditableLabelAptitude new
														glamorousCodeFont;
														defaultForeground: Color black;
														fontSize: 10).

										(GtCompletionController
											on: aLabel
											strategy: GtClassesCompletionStrategy new) install.

										aLabel ]).
						aTagger
							when: BrTaggerAddTagRequest
							do: [ :aRequest | 
								| aValue |
								aValue := (aTagger tags collect: #name)
										add: aRequest tag name;
										yourself.
								GtMagritteBuilderUtility
									write: aValue
									using: aDescription
									memento: aMemento
									element: aTagger ].
						aTagger
							when: BrTaggerRemoveTagRequest
							do: [ :aRequest | 
								| aValue |
								aValue := (aTagger tags collect: #name)
										remove: aRequest tag name;
										yourself.
								GtMagritteBuilderUtility
									write: aValue
									using: aDescription
									memento: aMemento
									element: aTagger ].
						aTagger
							withAsyncSinkDo: [ :anElementSink | 
								anElementSink
									sink: AsyncPeekSink new;
									whenUpdate: [ :theTagger :aSink | 
										| theValues theTexts |
										theValues := aSink value currentValue.
										theTexts := theValues
												collect: [ :each | aDescription displayStringFor: each ].
										theTagger namedTags: theTexts ].
								(aMemento readObservableValueUsing: aDescription) observe: anElementSink ] ]}
]
