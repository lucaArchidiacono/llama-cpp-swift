//
//  Llama.swift
//  
//
//  Created by Luca Archidiacono on 25.08.23.
//

import Foundation
import CLlama

public struct LlamaContextParams {
    /// RNG seed, -1 for random
    public var seed: UInt32 = LLAMA_DEFAULT_SEED
    /// Text Context
    public var context: Int32 = 512
    /// Prompt processing batch size
    public var batch: Int32 = 512
    /// Number of layers to store in VRAM
    public var gpuLayers: Int32 = 0
    /// The GPU that is used for scratch and small tensors
    public var mainGPU: Int32 = 0
    /// How to split layers across multiple GPUs (size: LLAMA_MAX_DEVICES)
    public var tensor_split: UnsafePointer<Float>? = nil
    /// RoPE base frequency
    public var ropeFreqBase: Float = 10000.0
    /// RoPE frequency scaling factor
    public var ropeFreqScale: Float = 1.0
    /// If true, reduce VRAM usage at the cost of performance
    public var lowVram: Bool = false
    /// If true, use experimental mul_mat_q kernels
    public var mulMatQ: Bool = false
    /// Use fp16 for KV cache
    public var f16KV: Bool = true
    /// The `llama_eval()` call computes all logits, not just the last one
    public var logitsAll: Bool = false
    /// Only load the vocabulary, no weights
    public var vocabOnly: Bool = false
    /// Use mmap if possible
    public var useMmap: Bool = true
    /// Force system to keep model in RAM
    public var useMlock: Bool = false
    /// Embedding mode only
    public var embedding: Bool = false

    public static let `default` = LlamaContextParams()
}

public enum LlamaError: Error {
    case modelNotFound(String)
    case inputTooLong
    case failedToEval
}

public class Llama {
    private let context: OpaquePointer?
    private var contextParams: LlamaContextParams
    
    public init(path: String, contextParams: LlamaContextParams = .default) throws {
        self.contextParams = contextParams
        var params = llama_context_default_params()
        params.seed = contextParams.seed
        params.n_ctx = contextParams.context
        params.n_batch = contextParams.batch
        params.n_gpu_layers = contextParams.gpuLayers
        params.main_gpu = contextParams.mainGPU
        params.tensor_split = contextParams.tensor_split
        params.rope_freq_base = contextParams.ropeFreqBase
        params.rope_freq_scale = contextParams.ropeFreqScale
        params.low_vram = contextParams.lowVram
        params.mul_mat_q = contextParams.mulMatQ
        params.f16_kv = contextParams.f16KV
        params.logits_all = contextParams.logitsAll
        params.vocab_only = contextParams.vocabOnly
        params.use_mmap = contextParams.useMmap
        params.use_mlock = contextParams.useMlock
        params.embedding = contextParams.embedding
        
        if !FileManager.default.fileExists(atPath: path) {
            throw LlamaError.modelNotFound(path)
        }
        
        let model = llama_load_model_from_file(path, params)
        
        guard let model = model else {
            throw LlamaError.failedToEval
        }
        
        context = llama_new_context_with_model(model, params)
        
    }
}

/*
 struct llama_context * llama_init_from_file(
                              const char * path_model,
             struct llama_context_params   params) {
     struct llama_model * model = llama_load_model_from_file(path_model, params);
     if (!model) {
         return nullptr;
     }

     struct llama_context * ctx = llama_new_context_with_model(model, params);
     ctx->model_owner = true;

     return ctx;
 }
 */
