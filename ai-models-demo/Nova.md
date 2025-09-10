---
date: 2025-09-08
Speaker: ydg
tags:
  - ust
  - ai
  - aws
  - nova
---

- **Amazon Nova** is a _family_ of foundation AI models developed by AWS==. It spans multiple modalities—text, image, video, speech—and provides powerful, cost-efficient intelligence for various applications[](https://aws.amazon.com/ai/generative-ai/nova/?utm_source=chatgpt.com)==
- Models in Nova
	- **Understanding models**: Text and multimodal models (Micro, Lite, Pro, Premier) for comprehension tasks.
	- **Creative models**: Nova Canvas (image generation) and Nova Reel (video generation).
	- **Speech model**: Nova Sonic (speech-to-speech, real-time conversations).
	- **Agentic model**: Nova Act, an AI agent capable of performing actions within a browser.

| Use Case / Priority                                               | Best Nova Model                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ----------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Low latency, highly cost-sensitive text tasks**                 | **Nova Micro** – text-only, blazing-fast, lowest cost [Amazon Web Services, Inc.+1](https://aws.amazon.com/ai/generative-ai/nova/?utm_source=chatgpt.com)[The Verge](https://www.theverge.com/2024/12/3/24312260/amazon-nova-foundation-ai-models-anthropic?utm_source=chatgpt.com)                                                                                                                                                                                                                                                                   |
| **Multimodal input (text, image, video) with budget constraints** | **Nova Lite** – lightning-fast, affordable, handles long contexts (300k tokens), images, video [Amazon Web Services, Inc.+1](https://aws.amazon.com/ai/generative-ai/nova/?utm_source=chatgpt.com)[Built In](https://builtin.com/articles/amazon-nova?utm_source=chatgpt.com)                                                                                                                                                                                                                                                                         |
| **Balanced accuracy, speed, and cost for complex tasks**          | **Nova Pro** – highly capable multimodal model, ideal for RAG, agentic workflows, document/video analysis, code, and software development [Amazon Web Services, Inc.+1](https://aws.amazon.com/ai/generative-ai/nova/?utm_source=chatgpt.com)[Built In](https://builtin.com/articles/amazon-nova?utm_source=chatgpt.com)                                                                                                                                                                                                                              |
| **Most capable model; works as a teacher for distillation**       | **Nova Premier** – powerful multimodal reasoning, used to distill smaller models; available early 2025 [About Amazon+1](https://www.aboutamazon.com/news/aws/amazon-nova-artificial-intelligence-bedrock-aws?utm_source=chatgpt.com)[Amazon Web Services, Inc.](https://aws.amazon.com/blogs/aws/introducing-amazon-nova-frontier-intelligence-and-industry-leading-price-performance/?utm_source=chatgpt.com)[Built In](https://builtin.com/articles/amazon-nova?utm_source=chatgpt.com)                                                             |
| **Generate high-quality images**                                  | **Nova Canvas** – studio-grade image generation, inpainting/outpainting, style controls, watermarking [Amazon Web Services, Inc.+1](https://aws.amazon.com/ai/generative-ai/nova/?utm_source=chatgpt.com)[The Verge](https://www.theverge.com/2024/12/3/24312260/amazon-nova-foundation-ai-models-anthropic?utm_source=chatgpt.com)                                                                                                                                                                                                                   |
| **Create short videos**                                           | **Nova Reel** – video generation, style & pacing control, up to ~2 minutes, watermarking for safety [Amazon Web Services, Inc.](https://aws.amazon.com/ai/generative-ai/nova/?utm_source=chatgpt.com)[About Amazon](https://www.aboutamazon.com/news/aws/amazon-nova-foundation-models-guide?utm_source=chatgpt.com)[The Verge](https://www.theverge.com/news/645357/amazon-nova-sonic-ai-conversational-voice-model-reel?utm_source=chatgpt.com)[Lifewire](https://www.lifewire.com/amazon-nova-ai-foundation-models-8755972?utm_source=chatgpt.com) |
| **Interactive voice agent applications**                          | **Nova Sonic** – real-time unified speech understanding and generation in multiple languages, tone-aware [About Amazon](https://www.aboutamazon.com/news/aws/amazon-nova-foundation-models-guide?utm_source=chatgpt.com)[The Verge](https://www.theverge.com/news/645357/amazon-nova-sonic-ai-conversational-voice-model-reel?utm_source=chatgpt.com)[AWS Documentation](https://docs.aws.amazon.com/nova/latest/userguide/what-is-nova.html?utm_source=chatgpt.com)                                                                                  |
| **Automated browser actions / agentic applications**              | **Nova Act** – builds agents that click, select, answer questions in a browser with SDK support; part of AGI push [Amazon Web Services, Inc.](https://aws.amazon.com/ai/generative-ai/nova/?utm_source=chatgpt.com)[Investors](https://www.investors.com/news/technology/amazon-stock-ai-agents-nova-tariffs-amzn-news/?utm_source=chatgpt.com)[WIRED](https://www.wired.com/story/amazon-ai-agents-nova-web-browsing?utm_source=chatgpt.com)                                                                                                         |


# Comparison Table 

|Scenario|Key Requirements|Best Fit (Global Leaders)|Best Fit (Nova Family)|Why?|
|---|---|---|---|---|
|**Cheap, fast text classification / chatbots**|Low latency, low cost, text-only|**GPT-4o mini** (OpenAI), **Mistral Small**|**Nova Micro**|Nova Micro is Amazon’s lowest-cost, ultra-fast text model; GPT-4o mini is strong for cheap reasoning.|
|**Enterprise-grade assistant**|Balanced reasoning, long context, safe deployment|**Claude 3.5 Sonnet** (Anthropic), **GPT-4o**|**Nova Pro**|Claude/GPT-4o excel in reasoning and reliability, Nova Pro balances accuracy, speed, and cost with enterprise RAG support.|
|**Multimodal app (chat w/ images, video analysis)**|Text + vision + video input, long context|**Gemini 1.5 Pro** (Google), **GPT-4o**|**Nova Pro** or **Nova Lite**|Nova Lite is cheaper/faster multimodal, Pro is stronger; Gemini/GPT-4o are best in class but pricier.|
|**Complex reasoning (finance, legal, code analysis)**|High accuracy, very long documents|**Claude 3.5 Opus** (Anthropic), **GPT-4 Turbo**|**Nova Premier** (early 2025)|Opus is currently best for reasoning depth; Nova Premier is designed as Amazon’s most capable reasoning model.|
|**Creative image generation**|High-quality, controllable image outputs|**DALL-E 3** (OpenAI), **Stable Diffusion XL**|**Nova Canvas**|Nova Canvas adds built-in watermarking + enterprise IP indemnity; DALL-E is stronger for creativity.|
|**Video generation**|Short videos with style control|**Sora** (OpenAI, private), **Runway Gen-3**|**Nova Reel**|Reel is available now for AWS users; Sora is most advanced but not broadly available.|
|**Voice agents / speech AI**|Real-time speech-to-speech|**GPT-4o voice mode** (OpenAI), **Speechmatics**|**Nova Sonic**|Sonic is AWS’s unified speech model with multilingual tone awareness; GPT-4o is stronger in naturalness.|
|**Autonomous browser agent**|AI that takes actions on websites|**GPT-4o w/ function calling**, **Anthropic agent SDKs**|**Nova Act**|Nova Act is built for browser actions via SDK, tuned for reliability; others rely on external agent frameworks.|
|**Cost-sensitive RAG deployment**|Querying enterprise knowledge bases|**Mistral Large** (open weights, cheap), **Claude Sonnet**|**Nova Lite** or **Nova Pro**|Nova integrates tightly with Bedrock Knowledge Bases, offering cost + grounding advantages in AWS stack.|


# Why Choose Nova Over Global Leaders?

- Price + latency advantage 
	- Nova Micro / Lite / Pro are **~75% cheaper** than equivalent models on Bedrock and optimized for **low latency**.
	- If your app makes **millions of calls per day**, cost per token matters way more than 1–2% accuracy on benchmarks.
- Deep AWS Integration
	- Natively tied into **Amazon Bedrock**, **Knowledge Bases**, **SageMaker**, **CloudWatch**, **IAM policies**.
	- Easier governance, monitoring, and security compliance if you’re already in AWS.
- Enterprise-Ready Safety & Trust
	- **Built-in moderation**, **watermarking** (Canvas/Reel), and **legal IP indemnity** from AWS
- Customization at Scale
	- Fine-tuning and **distillation workflows** are part of Nova’s design.
	- Nova Premier → distilled into Micro/Lite for cheaper specialized models.
	- Instead of paying for Claude/GPT for everything, enterprises can train a custom Nova Lite that’s 80% as good, at 20% of the cost


