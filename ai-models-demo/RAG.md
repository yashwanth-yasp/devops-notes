---
date: 2025-09-09
Speaker: Akshat Kamboj
tags:
  - ai
  - ust
---
- Before RAG there used to be factual inaccuracies because the model didn't have the context it needed 
- Fine tuning could solve this but it is costly for large models and one needs to be a expert to carry out fine tuning 
- Repeatedly fine-tuning against frequently changing data can be very costly 
- This problem is solved using RAG
- RAG is a way to make a language model smarter by giving it extra information at the time you ask your question 
- Query + Context to llm gives the response 
- it can be divided into 4 steps 
	- Indexing 
		- process of preparing your knowlege base so it can be efficiently search at query time 
		- Steps 
			- Document ingestion 
				- loading source knowledge into memory 
			- Text chunking 
				- idivide docs into semantically meaning chucks 
			- Embedding generation 
				- create a dense vector that will carry the sematic meaning of the chucnk 
			- Storage in vector store 
				- Store the vectors in a vector database 
	- Retrieval 
		- Understand the query, and based on the query we dervied chunks that can help us answer it 
	- Augumentation 
		- Where the context is combined with the query 
	- Generation
		- Final step where the final prompt with the query is sent to the llm and a response is taken 

