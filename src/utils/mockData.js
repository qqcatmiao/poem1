// 模拟数据，用于开发环境或 Supabase 未配置时

export const mockPoems = [
  {
    id: '1',
    title: '静夜思',
    content: '床前明月光，疑是地上霜。举头望明月，低头思故乡。',
    poet_name: '李白',
    dynasty: '唐',
    appreciation: '这首诗通过描绘月夜思乡的场景，表达了游子对故乡的深切思念。语言朴素自然，意境深远。',
    theme: '思乡',
    created_at: new Date().toISOString()
  },
  {
    id: '2',
    title: '春望',
    content: '国破山河在，城春草木深。感时花溅泪，恨别鸟惊心。烽火连三月，家书抵万金。白头搔更短，浑欲不胜簪。',
    poet_name: '杜甫',
    dynasty: '唐',
    appreciation: '这首诗反映了安史之乱时期的社会动荡和人民苦难，展现了诗人忧国忧民的情怀。',
    theme: '忧国',
    created_at: new Date().toISOString()
  },
  {
    id: '3',
    title: '水调歌头',
    content: '明月几时有？把酒问青天。不知天上宫阙，今夕是何年。我欲乘风归去，又恐琼楼玉宇，高处不胜寒。起舞弄清影，何似在人间。',
    poet_name: '苏轼',
    dynasty: '宋',
    appreciation: '这首词以中秋明月为背景，表达了作者对人生的思考和对亲人的思念，展现了苏轼豁达的人生态度。',
    theme: '人生哲理',
    created_at: new Date().toISOString()
  }
]

// 模拟收藏数据
export const mockFavorites = []

export const mockPoets = [
  {
    id: '1',
    name: '李白',
    dynasty: '唐',
    lifespan: '701年-762年',
    introduction: '唐代伟大的浪漫主义诗人，被后人誉为"诗仙"。'
  },
  {
    id: '2',
    name: '杜甫',
    dynasty: '唐',
    lifespan: '712年-770年',
    introduction: '唐代伟大的现实主义诗人，被后人誉为"诗圣"。'
  },
  {
    id: '3',
    name: '苏轼',
    dynasty: '宋',
    lifespan: '1037年-1101年',
    introduction: '北宋文学家、书画家，唐宋八大家之一。'
  }
]

// 模拟 API 响应延迟
const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms))

// 模拟 Supabase 客户端方法
export const createMockClient = () => {
  let currentUser = null
  let mockFavorites = []
  
  const createQueryBuilder = (table) => {
    let query = {
      selectColumns: '*',
      whereConditions: [],
      orderBy: null,
      limitCount: null,
      insertData: null,
      deleteConditions: []
    }
    
    const builder = {
      select(columns) {
        query.selectColumns = columns
        return builder
      },
      eq(field, value) {
        query.whereConditions.push({ field, value, operator: 'eq' })
        return builder
      },
      order(field, options = { ascending: false }) {
        query.orderBy = { field, ascending: options.ascending }
        return builder
      },
      ilike(field, pattern) {
        query.whereConditions.push({ field, pattern, operator: 'ilike' })
        return builder
      },
      limit(count) {
        query.limitCount = count
        return builder
      },
      insert(data) {
        query.insertData = data
        return builder
      },
      delete() {
        query.deleteConditions = query.whereConditions
        return builder
      },
      async single() {
        await delay(200)
        if (table === 'poems') {
          if (query.whereConditions.length > 0) {
            const condition = query.whereConditions[0]
            if (condition.field === 'id') {
              const poem = mockPoems.find(p => p.id === condition.value)
              if (poem) {
                const poemWithPoet = {
                  ...poem,
                  poets: mockPoets.find(p => p.name === poem.poet_name)
                }
                return { data: poemWithPoet, error: null }
              }
            }
          }
        }
        return { data: null, error: null }
      },
      async then(callback) {
        await delay(200)
        
        if (table === 'poems') {
          let resultData = [...mockPoems]
          
          // 应用排序
          if (query.orderBy) {
            resultData.sort((a, b) => {
              if (query.orderBy.ascending) {
                return new Date(a.created_at) - new Date(b.created_at)
              }
              return new Date(b.created_at) - new Date(a.created_at)
            })
          }
          
          // 应用限制
          if (query.limitCount) {
            resultData = resultData.slice(0, query.limitCount)
          }
          
          // 应用搜索条件
          if (query.whereConditions.length > 0) {
            query.whereConditions.forEach(condition => {
              if (condition.operator === 'ilike') {
                const searchTerm = condition.pattern.replace(/%/g, '')
                resultData = resultData.filter(item => 
                  item[condition.field]?.toLowerCase().includes(searchTerm.toLowerCase())
                )
              }
            })
          }
          
          // 为诗词数据添加诗人信息
          const poemsWithPoets = resultData.map(poem => ({
            ...poem,
            poets: mockPoets.find(p => p.name === poem.poet_name)
          }))
          
          callback({ data: poemsWithPoets, error: null })
        } 
        else if (table === 'favorites') {
          // 处理收藏相关操作
          if (query.insertData) {
            // 添加收藏
            const newFavorite = {
              id: Date.now().toString(),
              poem_id: query.insertData[0].poem_id,
              user_id: query.insertData[0].user_id,
              created_at: new Date().toISOString()
            }
            mockFavorites.push(newFavorite)
            callback({ data: null, error: null })
          }
          else if (query.deleteConditions.length > 0) {
            // 删除收藏
            const condition = query.deleteConditions[0]
            if (condition.field === 'poem_id' && condition.operator === 'eq') {
              const index = mockFavorites.findIndex(fav => 
                fav.poem_id === condition.value && fav.user_id === currentUser?.id
              )
              if (index > -1) {
                mockFavorites.splice(index, 1)
              }
            }
            callback({ data: null, error: null })
          }
          else {
            // 查询收藏
            let resultData = [...mockFavorites]
            
            // 应用条件过滤
            if (query.whereConditions.length > 0) {
              query.whereConditions.forEach(condition => {
                if (condition.field === 'user_id' && condition.operator === 'eq') {
                  resultData = resultData.filter(fav => fav.user_id === condition.value)
                }
                if (condition.field === 'poem_id' && condition.operator === 'eq') {
                  resultData = resultData.filter(fav => fav.poem_id === condition.value)
                }
              })
            }
            
            // 如果查询包含关联数据
            if (query.selectColumns && query.selectColumns.includes('poems')) {
              const favoritesWithPoems = resultData.map(fav => {
                const poem = mockPoems.find(p => p.id === fav.poem_id)
                return {
                  ...fav,
                  poems: {
                    ...poem,
                    poets: mockPoets.find(p => p.name === poem.poet_name)
                  }
                }
              })
              callback({ data: favoritesWithPoems, error: null })
            } else {
              callback({ data: resultData, error: null })
            }
          }
        }
        else {
          callback({ data: [], error: null })
        }
      }
    }
    
    // 使 builder 支持 Promise
    builder.then = builder.then
    return builder
  }
  
  return {
    auth: {
      async signUp() {
        await delay(500)
        const user = { id: 'mock-user-' + Date.now() }
        currentUser = user
        return { data: { user }, error: null }
      },
      async signInWithPassword() {
        await delay(500)
        const user = { id: 'mock-user' }
        currentUser = user
        return { data: { user }, error: null }
      },
      async signOut() {
        await delay(300)
        currentUser = null
        return { error: null }
      }
    },
    from(table) {
      return createQueryBuilder(table)
    }
  }
}